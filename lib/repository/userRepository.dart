import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../db_firestore.dart';
import '../model/Usuario.dart';
import '../service/auth_service.dart';

class UserRepository extends ChangeNotifier {
  List<Usuario> _lista = [];
  late FirebaseFirestore db;
  late AuthService auth;
  late Usuario usuarioLogado = new Usuario('uid', 'nome', 'email', 'telefone', 'apelido', 'passworld', false, false);


  UserRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() async {
    db = DBFirestore.get();
  }

  saveAll(List<Usuario> users) {
    users.forEach((user) async {
      await db.collection('user').doc(user.nome).set({'nome': user.nome});
    });
  }

  _getUser(Usuario usuario) {
    usuarioLogado = usuario;
    print('GET USER' + usuarioLogado.nome);
    notifyListeners();
  }

  setUserLogado(Map<String, dynamic> result) {
    usuarioLogado = Usuario.fromJson(result);
    print('setei o usuario logado');
    print('usuario logado'+usuarioLogado.toString());
    notifyListeners();
  }

  insertUser(Usuario user) async {
    try {
      await db.collection('user').doc(auth.usuario!.uid).set({
        'uid': user.uid,
        'nome': user.nome,
        'email': user.email,
        'telefone': user.telefone,
        'password': user.passworld,
        'apelido': user.apelido,
        'isAdmin': user.isAdmin,
        'ativo': user.ativo,
        'pontuacao': user.pontuacao != null ? user.pontuacao : 0,
        'avaliacaoApp': user.avaliacaoApp != null ? user.avaliacaoApp : '0',
        'busto': user.busto != null ? user.busto : '',
        'torax': user.torax != null ? user.torax : '',
        'bracos': user.bracos != null ? user.bracos : '',
        'cintura': user.cintura != null ? user.cintura : '',
        'abdomen': user.abdomen != null ? user.abdomen : '',
        'quadril': user.quadril != null ? user.quadril : '',
        'coxas': user.coxas != null ? user.coxas : '',
        'panturilha': user.panturilha != null ? user.panturilha : '',
      });
      _getUser(user);
    } catch (e) {
      print('erro ao inserir usuario no banco de dados' + e.toString());
    }
  }

  update(Usuario user) async {
    try {
      await db.collection('user').doc(user.uid).update({
        'nome': user.nome,
        'email': user.email,
        'telefone': user.telefone,
        'password': user.passworld,
        'apelido': user.apelido,
        'isAdmin': user.isAdmin,
        'ativo': user.ativo,
        'pontuacao': user.pontuacao != null ? user.pontuacao : 0,
        'avaliacaoApp': user.avaliacaoApp != null ? user.avaliacaoApp : '0',
        'busto': user.busto != null ? user.busto : '',
        'torax': user.torax != null ? user.torax : '',
        'bracos': user.bracos != null ? user.bracos : '',
        'cintura': user.cintura != null ? user.cintura : '',
        'abdomen': user.abdomen != null ? user.abdomen : '',
        'quadril': user.quadril != null ? user.quadril : '',
        'coxas': user.coxas != null ? user.coxas : '',
        'panturilha': user.panturilha != null ? user.panturilha : '',
      });
      _getUser(user);
    } catch (e) {
      print('erro ao fazer update de usuario no banco de dados' + e.toString());
    }
  }

  inactivateUser(Usuario user) async {
    try {
      await db.collection('user').doc(user.uid).update({
        'nome': user.nome,
        'email': user.email,
        'telefone': user.telefone,
        'password': user.passworld,
        'apelido': user.apelido,
        'isAdmin': user.isAdmin,
        'ativo': user.ativo,
        'pontuacao': user.pontuacao != null ? user.pontuacao : 0,
        'avaliacaoApp': user.avaliacaoApp != null ? user.avaliacaoApp : '0',
        'busto': user.busto != null ? user.busto : '',
        'torax': user.torax != null ? user.torax : '',
        'bracos': user.bracos != null ? user.bracos : '',
        'cintura': user.cintura != null ? user.cintura : '',
        'abdomen': user.abdomen != null ? user.abdomen : '',
        'quadril': user.quadril != null ? user.quadril : '',
        'coxas': user.coxas != null ? user.coxas : '',
        'panturilha': user.panturilha != null ? user.panturilha : '',
      });

    } catch (e) {
      print('erro ao fazer update de usuario no banco de dados' + e.toString());
    }
  }

  readUser(String uid) async {
    final snapshot = await db.collection('user').doc(uid).get();
    this.setUserLogado(snapshot.data()!);
  }

  revalidateUser(String uid) async {
    final snapshot = await db.collection('user').doc(uid).get();
    this.setUserLogado(snapshot.data()!);
  }

  Future<List<Usuario>> readAll() async {
     List<Map<String, dynamic>> listUser = [];

    final snapshot = await db.collection('user').get();
    snapshot.docs.forEach((doc) {
      listUser.add(doc.data());
      notifyListeners();
    });
    List<Usuario> lista =  usuarioLogado.fromArrayJson(listUser);
    return lista;
  }

  remove(Usuario usuario) async {
    await db.collection('user/${auth.usuario!.uid}').doc(usuario.nome).delete();
    _lista.remove(usuario);
    notifyListeners();
  }
}
