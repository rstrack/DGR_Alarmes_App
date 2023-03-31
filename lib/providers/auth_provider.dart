import 'dart:async';

import 'package:DGR_alarmes/control/database.dart';
import 'package:DGR_alarmes/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;
  User? _user;
  bool? _error;
  String? _errorMsg;

  User? get user => _user;
  bool? get error => _error;
  String? get errorMsg => _errorMsg;

  Future<void> setUser() async {
    _user = await Database.getUserAuth();
    notifyListeners();
  }

  void resetUser() {
    _user = null;
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

  signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      setUser().whenComplete(() {
        print(user);
        return;
      });
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
    resetUser();
  }

  signUp(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setError(true);
        setErrorMsg('Senha fraca!');
      } else if (e.code == 'email-already-in-use') {
        setError(true);
        setErrorMsg('Já existe uma conta com este e-mail.');
      }
    } catch (e) {
      setError(true);
      setErrorMsg(e.toString());
    }
    return firebaseAuth.currentUser!.uid;
  }
}

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier();
});
