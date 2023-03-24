import 'dart:async';

import 'package:DGR_alarmes/control/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;
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

  signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // setUser(userCredential.user);
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
    setUser(null);
  }

  registrar(String email, String password) async {
    // UserCredential? result;
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setError(true);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setError(true);
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return firebaseAuth.currentUser!.uid;
    // return result;
  }
}
