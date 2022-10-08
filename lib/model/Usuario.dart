import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Usuario extends ChangeNotifier {
  String uid;
  String nome;
  String email;
  String telefone;
  String apelido;
  String passworld;
  bool isAdmin;
  bool ativo;
  int pontuacao;
  double avaliacaoApp;
//estes campos serão preenchidos posteriormente como o usuario já cadastrado, e o usuario deve conseguir usar sem preenche-los.


  String? busto;
  String? torax;
  String? bracos;
  String? cintura;
  String? abdomen;
  String? quadril;
  String? coxas;
  String? panturilha;

  Usuario(this.uid, this.nome, this.email, this.telefone, this.apelido,
      this.passworld, this.isAdmin, this.ativo, this.pontuacao, this.avaliacaoApp);

  Usuario.fromJson(Map<String, dynamic> json)
      : uid = json['uid'].toString(),
        nome = json['nome'].toString(),
        email = json['email'].toString(),
        telefone = json['telefone'].toString(),
        apelido = json['apelido'].toString(),
        passworld = json['passworld'].toString(),
        isAdmin = json['isAdmin'],
        pontuacao = json['pontuacao'],
        avaliacaoApp = double.tryParse(json['avaliacaoApp'].toString())!,
        busto = json['busto'].toString(),
        torax = json['torax'].toString(),
        bracos = json['bracos'].toString(),
        cintura = json['cintura'].toString(),
        abdomen = json['abdomen'].toString(),
        quadril = json['quadril'].toString(),
        coxas = json['coxas'].toString(),
        panturilha = json['panturilha'].toString(),
        ativo = json['ativo'];

  List<Usuario> fromArrayJson(List<Map<String, dynamic>> list) {
    List<Usuario> listUser = [];
    for (var x = 0; x < list.length; x++) {
      var uid = list[x]['uid'].toString();
      var nome = list[x]['nome'].toString();
      var email = list[x]['email'].toString();
      var telefone = list[x]['telefone'].toString();
      var apelido =  list[x]['apelido'].toString();
      var passworld = list[x]['passworld'].toString();
      var isAdmin = list[x]['isAdmin'];
      var pontuacao = list[x]['pontuacao'];
      var avaliacaoApp = list[x]['avaliacaoApp'];
      var busto = list[x]['busto'].toString();
      var torax = list[x]['torax'].toString();
      var bracos = list[x]['bracos'].toString();
      var cintura = list[x]['cintura'].toString();
      var abdomen = list[x]['abdomen'].toString();
      var quadril = list[x]['quadril'].toString();
      var coxas = list[x]['coxas'].toString();
      var panturilha = list[x]['panturilha'].toString();
      var ativo = list[x]['ativo'];
      Usuario user = new Usuario(uid, nome, email, telefone, apelido, passworld,
          isAdmin, ativo, pontuacao, 0);
      listUser.add(user);
    }

    return listUser;
  }

  @override
  String toString() {
    return 'Usuario{uid: $uid, nome: $nome, email: $email, telefone: $telefone, apelido: $apelido, passworld: $passworld, isAdmin: $isAdmin, pontuacao: $pontuacao, avaliacaoApp: $avaliacaoApp, busto: $busto, torax: $torax, bracos: $bracos, cintura: $cintura, abdomen: $abdomen, quadril: $quadril, coxas: $coxas, panturilha: $panturilha, ativo: $ativo}';
  }
}
