import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/repository/userRepository.dart';
import 'package:ta_pago/widgtes/register_measurements.dart';

import 'homePage.dart';

class Measurements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userLogado = context.read<UserRepository>().usuarioLogado;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Bem vindo ${userLogado.apelido != '' ? userLogado.apelido : userLogado.nome} ao desafio 21 dias!!!'),
      ),
      body: SimpleDialog(
        titlePadding: EdgeInsets.all(15),
        insetPadding: EdgeInsets.all(15),
        title: const Text(
            'Na proxima tela informe alguma medidas, siga a foto em caso de duvidas!'),
        children: <Widget>[
          Image.asset('assets/img/Medidas.jpeg'),
          SimpleDialogOption(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return RegisterMeasurements();
                  },
                ),
              );
            },
            child: const Text('Inserir medidas'),
          ),
          SimpleDialogOption(
            child: const Text('Sair'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                   return HomePage();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
/*Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Image.asset('assets/img/Medidas.jpeg'),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Container( child: ElevatedButton(onPressed: () {}, child: Text('Avançar'))),
      )],*/
