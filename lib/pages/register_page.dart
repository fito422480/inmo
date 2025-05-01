import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:inmo/components/button.dart';
import 'package:inmo/components/text_field.dart';

class RegisterPage extends StatelessWidget {
  final Function()? onTap;

  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: SafeArea(
        child: RegisterForm(onTap: onTap),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final Function()? onTap;

  const RegisterForm({Key? key, required this.onTap}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isButtonDisabled = true;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = packageInfo.version + '.' + packageInfo.buildNumber;
      });
    }
  }

  void _toggleButton() {
    setState(() {
      _isButtonDisabled = _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty;
    });
  }

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _displayMessage(context, "Las contraseñas no coinciden.");
      return;
    }

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'username': _emailController.text.split('@')[0],
      });

      // Verificar si el widget está montado antes de llamar a Navigator.pop(context)
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      _displayMessage(context, _getErrorMessage(e.code));
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este email ya está en uso. Por favor, inicia sesión.';
      case 'weak-password':
        return 'La contraseña es demasiado débil. Inténtalo con una contraseña más segura.';
      default:
        return 'Se produjo un error al crear la cuenta. Por favor, inténtalo de nuevo.';
    }
  }

  void _displayMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
            SizedBox(height: 5),
            MyTextField(
              controller: _emailController,
              hintText: 'Email',
              obscureText: false,
              keyboardType: TextInputType.text,
              onChanged: (_) => _toggleButton(),
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: _passwordController,
              hintText: 'Contraseña',
              obscureText: true,
              keyboardType: TextInputType.text,
              onChanged: (_) => _toggleButton(),
            ),
            SizedBox(height: 15),
            MyTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirmar contraseña',
              obscureText: true,
              keyboardType: TextInputType.text,
              onChanged: (_) => _toggleButton(),
            ),
            SizedBox(height: 15),
            MyButton(
              onTap: _isButtonDisabled ? null : _signUp,
              text: "CREAR CUENTA",
              disabled: _isButtonDisabled,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¿Ya tienes una cuenta?'),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 92),
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
            SizedBox(height: 5),
            Text(
              'Copyright © 2024 inmo.\nTodos los derechos reservados',
              style: TextStyle(color: Colors.black54, fontSize: 11),
              textAlign: TextAlign.center,
              softWrap: true,
            )
          ],
        ),
      ),
    );
  }
}
