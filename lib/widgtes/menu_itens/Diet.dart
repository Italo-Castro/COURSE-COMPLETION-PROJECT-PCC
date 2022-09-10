import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repository/userRepository.dart';

import 'package:collapsible_sidebar/collapsible_sidebar.dart';

import '../menuItens.dart';

class Diet extends StatefulWidget {
  const Diet({Key? key}) : super(key: key);

  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  @override
  Widget build(BuildContext context) {
    final usserLogged =
        Provider.of<UserRepository>(context, listen: false).usuarioLogado;

    return Scaffold(
      appBar: AppBar(
        title: Text('Alimentação do projeto!'),
        centerTitle: true,
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: menuItens(context, 'diet'),
          textStyle: TextStyle(),
          avatarImg: AssetImage('assets/img/personGymProfile.png'),
          isCollapsed: false,
          title: 'Ola ${usserLogged.nome}!',
          titleStyle: TextStyle(
            fontSize: 22,
          ),
          toggleTitleStyle: TextStyle(),
          toggleTitle: ('Esconder'),
          body: Container(),
        ),
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Text('Siga a dieta durante os 21 dias!',
                      style: TextStyle(color: Colors.redAccent)),
                  elevation: 21,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: const [
                Card(
                  child: Text('Café da Manhã '),
                ),
                Card(
                  child: Text(
                    '1 copo de água com limão e uma colher de chia. \n \n 1º Opção -> 2 ovos mechidos.  \n\n 2º Opção -> 1 fatia de pão integral  xícara de café sem açúcar. \n \n 3º Opção ->  Meio Mamão.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  elevation: 21,
                  borderOnForeground: true,
                  shadowColor: Colors.blueAccent,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
