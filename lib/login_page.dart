import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final auth = FirebaseAuth.instance;
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // if (result.user != null) {
      //   Navigator.of(context).pushReplacementNamed('/login_page');
      // }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
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
                  color: Colors.indigo[600],
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
                        onPressed: _isLoading
                            ? null
                            : () {
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
}
