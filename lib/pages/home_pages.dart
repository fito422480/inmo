import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:inmo/components/drawer.dart';
import 'package:inmo/pages/compras_pages.dart';
import 'package:inmo/pages/exportar_csv.dart';
import 'package:inmo/pages/ventas_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void onCompras() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ComprasPage()));
  }

  void onVentas() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const VentasPage()));
  }

  void onReport() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ExportPage()));
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  var f = NumberFormat("#,##0", "es_ES");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Panel de Inicio'),
        foregroundColor: Colors.grey[300],
        backgroundColor: Colors.grey[900],
      ),
      drawer: MyDrawer(
        onComprasTap: onCompras,
        onSignOutTap: signOut,
        onVentasTap: onVentas,
        onReportesTap: onReport,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Compras')
                  .where('user', isEqualTo: currentUser!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                int totalCompras = 0;
                if (snapshot.hasData) {
                  totalCompras = snapshot.data!.docs.length;
                }
                return DashboardIndicator(
                  icon: Icons.shopping_cart,
                  title: 'Compras Registradas',
                  value: totalCompras,
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Ventas')
                  .where('user', isEqualTo: currentUser!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                int totalVentas = 0;
                if (snapshot.hasData) {
                  totalVentas = snapshot.data!.docs.length;
                }
                return DashboardIndicator(
                  icon: Icons.shopify,
                  title: 'Ventas Registradas',
                  value: totalVentas,
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Compras')
                  .where('user', isEqualTo: currentUser!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                int totalEgresos = 0;
                if (snapshot.hasData) {
                  totalEgresos = snapshot.data!.docs.length;
                }
                return DashboardIndicator(
                  icon: Icons.money_off,
                  title: 'Egresos Registrados',
                  value: totalEgresos,
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Ventas')
                  .where('user', isEqualTo: currentUser!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                int totalIngresos = 0;
                if (snapshot.hasData) {
                  totalIngresos = snapshot.data!.docs.length;
                }
                return DashboardIndicator(
                  icon: Icons.attach_money,
                  title: 'Ingresos Registrados',
                  value: totalIngresos,
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Compras')
                  .where('user', isEqualTo: currentUser!.email)
                  .snapshots(),
              builder: (context, comprasSnapshot) {
                int totalComprasAmount = 0;
                String MontoTotal = "";
                if (comprasSnapshot.hasData) {
                  final docs = comprasSnapshot.data!.docs;
                  totalComprasAmount = docs.fold<int>(
                      0,
                      (previousValue, doc) =>
                          previousValue + doc['montoTotalComprobante'] as int);
                  MontoTotal = f.format(totalComprasAmount);
                }
                return DashboardIndicator1(
                  icon: Icons.monetization_on_outlined,
                  title: 'Monto Total Compras',
                  value: MontoTotal,
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Ventas')
                  .where('user', isEqualTo: currentUser!.email)
                  .snapshots(),
              builder: (context, ventasSnapshot) {
                int totalVentasAmount = 0;
                String MontoTotal = "";
                if (ventasSnapshot.hasData) {
                  final docs = ventasSnapshot.data!.docs;
                  totalVentasAmount = docs.fold<int>(
                      0,
                      (previousValue, doc) =>
                          previousValue + doc['montoTotalComprobante'] as int);
                  MontoTotal = f.format(totalVentasAmount);
                }
                return DashboardIndicator1(
                  icon: Icons.monetization_on_outlined,
                  title: 'Monto Total Ventas',
                  value: MontoTotal,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardIndicator extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;

  const DashboardIndicator({
    required this.title,
    required this.value,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[50],
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardIndicator1 extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DashboardIndicator1({
    required this.title,
    required this.value,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[50],
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
