import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para obtener la información del usuario
import 'package:inmo/components/listdrawer.dart'; // Asegúrate de importar el componente necesario aquí

class MyDrawer extends StatelessWidget {
  final void Function()? onHomeTap;
  final void Function()? onSignOutTap;
  final void Function()? onComprasTap;
  final void Function()? onVentasTap;
  final void Function()? onIngresosTap;
  final void Function()? onEgresosTap;
  final void Function()? onReportesTap;
  final void Function()? onSettingsTap;

  const MyDrawer({
    Key? key,
    this.onHomeTap,
    this.onSignOutTap,
    this.onComprasTap,
    this.onVentasTap,
    this.onIngresosTap,
    this.onEgresosTap,
    this.onReportesTap,
    this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser; // Obtiene el usuario actual
    String? userProfileImageUrl =
        user?.photoURL; // Obtiene la URL de la imagen del perfil de Google

    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(
                        224, 224, 224, 1), // Color de fondo del contenedor
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.2), // Color de la sombra
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // Desplazamiento de la sombra
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: userProfileImageUrl != null
                        ? NetworkImage(userProfileImageUrl)
                        : null, // Establece la imagen de perfil, si está disponible, de lo contrario, establece como nulo
                    radius: 45,
                    child: userProfileImageUrl == null
                        ? Icon(Icons.person, size: 64, color: Colors.white)
                        : null, // Si no hay imagen de perfil, muestra el ícono de persona
                  ),
                ),
              ),
              MyListTitle(
                icon: Icons.home,
                text: 'I N I C I O',
                onTap: onHomeTap,
              ),
              MyListTitle(
                icon: Icons.shopping_cart,
                text: 'C O M P R A S',
                onTap: onComprasTap, //
              ),
              MyListTitle(
                icon: Icons.shopify,
                text: 'V E N T A S',
                onTap: onVentasTap,
              ),
              MyListTitle(
                icon: Icons.attach_money,
                text: 'I N G R E S O S',
                onTap: onIngresosTap,
              ),
              MyListTitle(
                icon: Icons.money_off,
                text: 'E G R E S O S',
                onTap: onEgresosTap,
              ),
              MyListTitle(
                icon: Icons.summarize,
                text: 'R E P O R T E S',
                onTap: onReportesTap,
              ),
              /* MyListTitle(
                icon: Icons.settings,
                text: 'C O N F I G U R A C I O N',
                onTap: onSettingsTap,
              ), */
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTitle(
              icon: Icons.logout,
              text: 'Salir',
              onTap: onSignOutTap,
            ),
          ),
        ],
      ),
    );
  }
}
