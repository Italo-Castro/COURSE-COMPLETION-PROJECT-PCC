import 'package:flutter/material.dart';

class Configuration extends ChangeNotifier {
  String dataInicial;
  String dataFinal;
  bool ativo;

  Configuration(this.dataInicial, this.dataFinal, this.ativo);

  Configuration fromArrayJson(Map<String, dynamic> object) {
    var dataInicial = object['dataInicio'].toString();
    var dataFinal = object['dafaFim'].toString();
    var ativo = object['ativo'];

    Configuration cfg = new Configuration(dataInicial, dataFinal, ativo);

    return cfg;
  }
}
