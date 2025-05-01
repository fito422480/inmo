import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inmo/components/button.dart';
import 'package:inmo/components/square_tile.dart';
import 'package:inmo/components/text_field.dart';
import 'package:inmo/services/auth_services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _appVersion = '';
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = '${packageInfo.version}.${packageInfo.buildNumber}';
      });
    }
  }

  void _displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'El formato del correo electrónico es incorrecto.';
      case 'user-disabled':
        return 'Esta cuenta de usuario ha sido deshabilitada.';
      case 'user-not-found':
        return 'No se encontró ninguna cuenta de usuario con este correo electrónico.';
      case 'wrong-password':
        return 'La contraseña proporcionada es incorrecta.';
      // Agrega más casos según sea necesario para manejar otros códigos de error de Firebase.
      default:
        return 'Ocurrió un error al iniciar sesión. Por favor, inténtalo de nuevo más tarde.';
    }
  }

  void _displayFirebaseError(FirebaseAuthException e) {
    String errorMessage = _getErrorMessage(e.code);
    _displayMessage(errorMessage);
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      _displayFirebaseError(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/images/logo.png',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 5),
                MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordTextController,
                  hintText: 'Contraseña',
                  obscureText: true,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 15),
                MyButton(
                  onTap: _isLoading ? null : _signIn,
                  text: "INGRESAR",
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes una cuenta?'),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Registrate!',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 85),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/assets/images/google.png',
                    ),
                    const SizedBox(width: 15),
                    SquareTile(
                      onTap: () => AuthService().signInWithMicrosoft(),
                      imagePath: 'lib/assets/images/microsoft.png',
                    ),
                    const SizedBox(width: 15),
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/assets/images/facebook.png',
                    ),
                    const SizedBox(width: 15),
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/assets/images/x.png',
                    ),
                  ],
                ),
                const SizedBox(height: 95),
                Text(
                  'Version: $_appVersion',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Copyright © 2024 inmo.\nTodos los derechos reservados',
                  style: TextStyle(color: Colors.black54, fontSize: 11),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
