import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;
  bool? _error;
  String? _errorMsg;

  bool? get error => _error;
  String? get errorMsg => _errorMsg;

  void setError(bool error) {
    _error = error;
    notifyListeners();
  }

  void setErrorMsg(String errorMsg) {
    _errorMsg = errorMsg;
    notifyListeners();
  }

  signInWithEmailAndPassword(String email, String password) async {
    try {
      setError(false);
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
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
    await firebaseAuth.signOut();
  }

  Future<String?> signUp(String email, String password) async {
    try {
      setError(false);
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setError(true);
        setErrorMsg('Senha fraca!');
        return null;
      } else if (e.code == 'email-already-in-use') {
        setError(true);
        setErrorMsg('Já existe uma conta com este e-mail.');
        return null;
      }
    } catch (e) {
      setError(true);
      setErrorMsg(e.toString());
      return null;
    }
    return null;
  }
}

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier();
});

final streamAuthProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);
