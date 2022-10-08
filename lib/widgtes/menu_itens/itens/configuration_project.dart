import 'dart:async';
import 'dart:io';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:ta_pago/repository/configurationRepository.dart';
import '../../../model/Configurations.dart';
import '../../../repository/userRepository.dart';
import '../menuItensAdmin.dart';
import 'package:provider/provider.dart';

import '../menuItensNotAdmin.dart';

class ConfigurationProject extends StatefulWidget {
  const ConfigurationProject({Key? key}) : super(key: key);

  @override
  State<ConfigurationProject> createState() => _ConfigurationProjectState();
}

class _ConfigurationProjectState extends State<ConfigurationProject> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  String dataInicio = '';

  String dataFim = '';

  @override
  Widget build(BuildContext context) {
    final usserLogged =
        Provider.of<UserRepository>(context, listen: true).usuarioLogado;
    try {
      Provider.of<ConfigurationRepository>(context, listen: true).readAll();
    } on Exception catch (e) {
      showToast(
        'oi',
        context: context,
        backgroundColor: Colors.red,
        position: StyledToastPosition.bottom,
        animation: StyledToastAnimation.slideFromRight,
        alignment: const Alignment(50, 0),
        textStyle: TextStyle(foreground: Paint()),
        toastHorizontalMargin: 12,
        isHideKeyboard: true,
        reverseCurve: Curves.fastLinearToSlowEaseIn,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 3),
        curve: Curves.fastLinearToSlowEaseIn,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações do Projeto'),
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: usserLogged.isAdmin
              ? menuItens(context, 'configuration_project')
              : menuItensNotAdmin(context, 'configuration_project'),
          textStyle: const TextStyle(),
          avatarImg: const AssetImage('assets/img/personGymProfile.png'),
          isCollapsed: false,
          title: 'Ola ${usserLogged.nome}!',
          titleStyle: const TextStyle(
            fontSize: 22,
          ),
          toggleTitleStyle: const TextStyle(),
          toggleTitle: ('Esconder'),
          body: Container(),
        ),
      ),
      body: Consumer<ConfigurationRepository>(builder: (context, valor, child) {
        return (valor.cfgRepository == null || !valor.cfgRepository.ativo
            ? Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: valor.cfgRepository.ativo
                          ? Text(
                              'Projeto Ativo',
                              style: TextStyle(
                                fontSize: 22,
                                backgroundColor: Colors.greenAccent,
                                foreground: Paint(),
                              ),
                            )
                          : Text(
                              'O projeto não está ativo!',
                              style: TextStyle(
                                fontSize: 22,
                                backgroundColor: Colors.redAccent,
                                foreground: Paint(),
                              ),
                            ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: const Text("Nenhuma configuração encontrada!"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: Text('Defina a data inicial e final do projeto'),
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.calendar_month),
                      onPressed: () async {
                        var dataInicialEscolhida = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2022, 01, 01),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2025),
                        );
                        setState(() {
                          dataInicio =
                              "${dataInicialEscolhida?.day.toString().padLeft(2, '0') ?? ''}/${dataInicialEscolhida?.month.toString().padLeft(2, '0') ?? ''}/${dataInicialEscolhida?.year.toString()}";
                          int diaFim = dataInicialEscolhida != null
                              ? dataInicialEscolhida.day + 21
                              : 0;
                          dataFim =
                              "${(diaFim).toString()}/${dataInicialEscolhida?.month.toString().padLeft(2, '0') ?? ''}/${dataInicialEscolhida?.year.toString()}";
                        });
                      },
                    ),
                    Card(
                      child: Text('Data Inicial ${dataInicio}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 22),
                      child: FloatingActionButton(
                        heroTag: null,
                        child: Icon(Icons.calendar_month),
                        onPressed: () async {
                          var dataFinalEscolhida = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2022, 01, 01),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2025),
                          );
                          setState(() {
                            dataFim =
                                "${dataFinalEscolhida?.day.toString().padLeft(2, '0') ?? ''}/${dataFinalEscolhida?.month.toString().padLeft(2, '0') ?? ''}/${dataFinalEscolhida?.year.toString()}";
                          });
                        },
                      ),
                    ),
                    Card(
                      child: Text('Data Final ${dataFim}'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          try {

                            DateTime date = DateTime(29,09,22);
                            DateTime date2 = DateTime(29,10,22);

                          print( 'diferenca' + date.compareTo(date2).toString());

                            Provider.of<ConfigurationRepository>(context,
                                    listen: false)
                                .insert(
                                    Configuration(dataInicio, dataFim, true));
                            showToast(
                              'Projeto iniciado de ${dataInicio} até! ${dataFim}',
                              context: context,
                              backgroundColor: Colors.blueAccent,
                              position: StyledToastPosition.bottom,
                              animation: StyledToastAnimation.slideFromRight,
                              alignment: const Alignment(50, 0),
                              textStyle: TextStyle(foreground: Paint()),
                              toastHorizontalMargin: 12,
                              isHideKeyboard: true,
                              reverseCurve: Curves.fastLinearToSlowEaseIn,
                              animDuration: const Duration(seconds: 3),
                              duration: const Duration(seconds: 6),
                              curve: Curves.fastLinearToSlowEaseIn,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                            );
                          } catch (e) {
                            showToast(
                              'oi',
                              context: context,
                              backgroundColor: Colors.red,
                              position: StyledToastPosition.bottom,
                              animation: StyledToastAnimation.slideFromRight,
                              alignment: const Alignment(50, 0),
                              textStyle: TextStyle(foreground: Paint()),
                              toastHorizontalMargin: 12,
                              isHideKeyboard: true,
                              reverseCurve: Curves.fastLinearToSlowEaseIn,
                              animDuration: const Duration(seconds: 1),
                              duration: const Duration(seconds: 3),
                              curve: Curves.fastLinearToSlowEaseIn,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                            );
                          }
                        },
                        child: Text('Salvar Configurações'))
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Projeto Ativo',
                      style: TextStyle(
                        fontSize: 22,
                        backgroundColor: Colors.greenAccent,
                        foreground: Paint(),
                      ),
                    ),
                    Card(
                      child: Text(
                          'Data Inicio ${valor.cfgRepository.dataInicial }'),
                    ),
                    Card(
                      child: Text(
                          'Data Finial ${valor.cfgRepository.dataFinal.toString()}'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          valor.cfgRepository.ativo = false;
                          Provider.of<ConfigurationRepository>(context,
                                  listen: false)
                              .update(valor.cfgRepository);
                          setState(() {
                            showToast(
                              'Projeto encerrado!',
                              context: context,
                              backgroundColor: Colors.blueAccent,
                              position: StyledToastPosition.bottom,
                              animation: StyledToastAnimation.slideFromRight,
                              alignment: const Alignment(50, 0),
                              textStyle: TextStyle(foreground: Paint()),
                              toastHorizontalMargin: 12,
                              isHideKeyboard: true,
                              reverseCurve: Curves.fastLinearToSlowEaseIn,
                              animDuration: const Duration(seconds: 1),
                              duration: const Duration(seconds: 3),
                              curve: Curves.fastLinearToSlowEaseIn,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                            );
                          });
                        },
                        child: Text('Encerrar projeto!'))
                  ],
                ),
              ));
      }),
    );
  }
}
