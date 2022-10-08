import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:ta_pago/model/Configurations.dart';

import '../db_firestore.dart';
import '../service/auth_service.dart';

class ConfigurationRepository extends ChangeNotifier {
  late FirebaseFirestore db;
  late AuthService auth;
  late Configuration cfgRepository = new Configuration('vazio', 'vazio', false);

  _getConfiguration(Configuration cfg) {
    cfgRepository = cfg;
    notifyListeners();
  }

  ConfigurationRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() async {
    db = DBFirestore.get();
  }

  insert(Configuration cfg) async {
    print("vou gravar no bd" + cfg.dataInicial);
    try {
      await db.collection('configuration').doc('configuration').set({
        'dataInicio': cfg.dataInicial,
        'dafaFim': cfg.dataFinal,
        'ativo': cfg.ativo
      });
      readAll();
    } catch (e) {
      print('erro ao inserir CONFIGURAÇÃO no banco de dados \n' + e.toString());
    }
  }

  update(Configuration cfg) async {
    try {
      await db
          .collection('configuration')
          .doc('configuration')
          .update({'dataInicio': cfg.dataInicial, 'dafaFim': cfg.dataFinal, 'ativo': cfg.ativo});
      readAll();
    } catch (e) {
      print('erro ao inserir CONFIGURAÇÃO no banco de dados' + e.toString());
      throw Exception('Sem permissão para acessar banco de dados.');
    }
  }

  readAll() async {
    List<Map<String, dynamic>> listaCfg = [];
    try {
      final snapshot = await db.collection('configuration').get();
      snapshot.docs.forEach((doc) {
        listaCfg.add(doc.data());
      });
      if (listaCfg.length > 0) {
        Configuration cfgObj = cfgRepository.fromArrayJson(listaCfg[0]);
        _getConfiguration(cfgObj);
      }
    } catch (e) {
      print('erro ao buscar coleção cfg do firebase message -> \n' +
          e.toString());
      throw AuthException('Sem permissão para acessar banco de dados.');
    }
  }
}
