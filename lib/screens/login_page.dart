// ignore_for_file: use_build_context_synchronously

import 'package:DGR_alarmes/providers/auth_provider.dart';
import 'package:DGR_alarmes/utils/snack_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  String _errorMessage = '';
  final auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _login() async {
    setState(() {
      _isLoading = !_isLoading;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      UserCredential? userCredential =
          await Provider.of<AuthProvider>(context, listen: false)
              .signInWithEmailAndPassword(email, password);

      if (userCredential != null) {
        Navigator.pushNamed(context, '/home_page');
      } else {
        showCustomSnackbar(
            context: context,
            text: "E-mail ou senha incorretos",
            color: Colors.black87);
        setState(() {
          _isLoading = !_isLoading;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{'createdUser': false}) as Map;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/register_page');
            },
            child: const Text(
              'Cadastre-se',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                  color: Theme.of(context).primaryColor,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe um e-mail!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe a senha!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Entrar'),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                        ),
                      ),
                      // Text((FirebaseAuth.instance.currentUser == null)
                      //     ? "Não encontrado!"
                      //     : FirebaseAuth.instance.currentUser!.email!)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
//   void _showMessage(String message) {
//   _scaffoldKey.currentState?.(SnackBar(content: Text(message),));
// }
}
