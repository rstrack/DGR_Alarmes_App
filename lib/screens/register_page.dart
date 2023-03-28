// import 'package:DGR_alarmes/models/User.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../control/database_rtdb.dart';
import '../models/User.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
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
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted && result.user != null) {
        await DatabaseRTDB.createUser(
            user(id: result.user!.uid, email: email, name: name));

        Navigator.pushNamedAndRemoveUntil(
            context, '/login_page', (route) => false,
            arguments: {'createdUser': true});
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   'assets/logo.png',
                //   width: MediaQuery.of(context).size.width * 0.6,
                //   color: Theme.of(context).primaryColor,
                // ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Nome completo',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe um nome!';
                          }
                          return null;
                        },
                      ),
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
                            : const Text('Cadastrar'),
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
