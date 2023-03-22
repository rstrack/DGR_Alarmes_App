import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  bool? _error;
  String? _errorMsg;

  User? get user => _user;
  bool? get error => _error;
  String? get errorMsg => _errorMsg;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void setError(bool error) {
    _error = error;
    notifyListeners();
  }

  void setErrorMsg(String errorMsg) {
    _errorMsg = errorMsg;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      setUser(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setError(true);
        setErrorMsg('Usuário não encontrado!');
      } else if (e.code == 'wrong-password') {
        setError(true);
        setErrorMsg('Senha inválida!');
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    setUser(null);
  }
}
