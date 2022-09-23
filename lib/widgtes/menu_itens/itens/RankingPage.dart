import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/Usuario.dart';
import '../../../repository/userRepository.dart';
import '../../../service/connection.dart';
import '../menuItensAdmin.dart';
import '../menuItensNotAdmin.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class RankingPage extends StatefulWidget {
  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<Reference> refs = [];
  List<String> arquivos = [];
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final usserLogged =
        Provider.of<UserRepository>(context, listen: true).usuarioLogado;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking'),
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: menuItens(context, 'rankingPage'),
          textStyle: TextStyle(),
          avatarImg: AssetImage('assets/img/personGymProfile.png'),
          isCollapsed: false,
          title: 'Ola ${usserLogged.nome}!',
          titleStyle: const TextStyle(
            fontSize: 22,
          ),
          toggleTitleStyle: TextStyle(),
          toggleTitle: ('Esconder'),
          body: Container(),
        ),
      ),
      body: Provider.of<Connection>(context, listen: true).connection ==
              'Your mobile is no Internet Connection'
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/img/noConnection.jpeg', scale: 5),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Sem conexão com a internet!',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            )
          : FutureBuilder(
              future:
                  Provider.of<UserRepository>(context, listen: false).readAll(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Usuario>> snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    child: const Text('Nenhum aluno encontrado'),
                  ); // still loading
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      //numbers.sort((a, b) => a.length.compareTo(b.length));
                      child: RankingWidget(snapshot.data!),
                    ),
                  );
                }
                // return a widget here (you have to return a widget to the builder)
              },
            ),
    );
  }

  RankingWidget(List<Usuario> lista) {
    lista.sort((a, b) => (b.pontuacao).compareTo((a.pontuacao)));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/img/personGymProfile.png'),
                    ),
                  ),
                ),
                const Text('1° Lugar'),
                Text(lista[0].nome),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/img/personGymProfile.png'),
                      ),
                    ),
                  ),
                  Text('2 ° Lugar'),
                  Text(lista[1].nome),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 150),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                    Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image:  DecorationImage(
                        fit:  BoxFit.fill,
                        image:  AssetImage('assets/img/personGymProfile.png'),
                      ),
                    ),
                  ),
                  const Text('3° Lugar'),
                  Text(lista[2].nome),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text((index + 1).toString() + '°'),
                        ),
                        Text(lista[index].nome),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 12, top: 8, bottom: 4),
                      child: Column(
                        children: [
                          Text('Pontuação'),
                          Text(lista[index].pontuacao.toString()),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: lista.length,
          ),
        ),
      ],
    );
  }

/* montaRanking() async {
    try {
      List<Usuario> listUsers =
          await Provider.of<UserRepository>(context, listen: false).readAll();
      listUsers.sort((a, b) => (b.pontuacao).compareTo((a.pontuacao)));

      return listUsers;
    } catch (e) {
      print(e.toString());
      showToast(
        'Erro ao buscar usuarios!!',
        backgroundColor: Colors.red,
        context: context,
        position:
            const StyledToastPosition(align: Alignment.topRight, offset: 70),
        animation: StyledToastAnimation.slideFromRight,
        alignment: const Alignment(50, 0),
        textStyle: TextStyle(foreground: Paint()),
        toastHorizontalMargin: 12,
        isHideKeyboard: true,
        reverseCurve: Curves.fastLinearToSlowEaseIn,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 3),
        curve: Curves.fastLinearToSlowEaseIn,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      );
    }
  }*/
}
