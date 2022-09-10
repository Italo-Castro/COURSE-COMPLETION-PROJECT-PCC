import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;

  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;

    notifyListeners();
  }

  registrar(String email, String senha) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw AuthException('Email já cadastrado.');
      }
      if (e.code == 'weak-password') {
        throw AuthException('A senha precisa ter ao menos 6 caracteres.');
      }
      print('catch->' + e.toString() + 'Erro especifico ' + e.code);
    }
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      print(
          'loguei e nçao deu erro posso executar alguma função pra carregar o usuario');

      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado. Cadastre-se.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Tente novamente');
      }
      else if (e.code == 'network-request-failed') {
        throw AuthException('Sem conexão com a internet!');
      }
      print('erro ao lgoar->' + e.toString() + 'Erro especifico ' + e.code);

    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}
