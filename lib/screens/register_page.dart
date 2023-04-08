import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

import 'package:DGR_alarmes/controller/user_controller.dart';
import 'package:DGR_alarmes/models/user.dart';
import 'package:DGR_alarmes/providers/auth_provider.dart';
import 'package:DGR_alarmes/widgets/custom_snack_bar.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  final auth = FirebaseAuth.instance;
  String _errorMessage = '';

  _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      var localAuthProvider = ref.watch(authProvider);

      String? id =
          await ref.read(authProvider.notifier).signUp(email, password);
      print("ID: $id");
      //Testa se um erro não tratado foi identificado
      if (mounted && localAuthProvider.error == true) {
        showCustomSnackbar(context: context, text: localAuthProvider.errorMsg!);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (mounted && id != null) {
        await UserController.instance
            .createUser(User(id: id, email: email, name: name));
        Navigator.pushNamedAndRemoveUntil(
            context, '/login_page', (route) => false);
        showCustomSnackbar(
            context: context,
            text: "Usuário criado! Faça login para continuar");
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
                          if (value!.trim().isEmpty) {
                            return "Informe o nome";
                          }
                          if (value.trim().length <= 3) {
                            return "Nome deve possuir no mínimo 3 letras";
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
                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!);
                          if (value.isEmpty) {
                            return 'Informe um e-mail!';
                          }
                          if (!emailValid) {
                            return 'E-mail inválido!';
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
                          if (value!.length < 6) {
                            return "Senha curta! Insira no mínimo 6 caracteres";
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
                                  _signUp();
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
