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
  bool loading = false;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  List<Reference> refs1 = [];

  List<Reference> refs2 = [];
  List<Reference> refs3 = [];

  String arquivos1 = '';
  String arquivos2 = '';
  String arquivos3 = '';
  final FirebaseStorage storage = FirebaseStorage.instance;

  loadImageProfile1(String uid) async {
    try {
      if (arquivos1 == '') {
        refs1 = (await storage.ref('${uid}/').listAll()).items;
        for (var ref in refs1) {
          arquivos1 = await ref.getDownloadURL();
        }
        setState(() {});
      }
    } catch (e) {
      showToast(
        'Erro ao carregar imagens',
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
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      );
    }
  }

  loadImageProfile2(String uid) async {
    try {
      if (arquivos2 == '') {
        refs2 = (await storage.ref('${uid}/').listAll()).items;
        for (var ref in refs2) {
          arquivos2 = await ref.getDownloadURL();
        }
        setState(() {});
      }
    } catch (e) {
      showToast(
        'Erro ao carregar imagens',
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
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      );
    }
  }

  loadImageProfile3(String uid) async {
    try {
      if (arquivos3 == '') {
        refs3 = (await storage.ref('${uid}/').listAll()).items;
        for (var ref in refs3) {
          arquivos3 = await ref.getDownloadURL();
        }
        setState(() {});
      }
    } catch (e) {
      showToast(
        'Erro ao carregar imagens',
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
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<UserRepository>(context, listen: true).loadImages();

    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('Ranking'),
              Padding(
                padding: const EdgeInsets.only(left: 200.0),
                child: SizedBox(
                  width: 22,
                  child: FloatingActionButton(
                      mini: true,
                      child: Icon(
                        Icons.question_mark,
                        size: 12,
                      ),
                      onPressed: () {
                        _messangerKey.currentState?.showSnackBar(
                          SnackBar(
                            dismissDirection: DismissDirection.down,
                            backgroundColor: Colors.white70,
                            content: Text(
                              'Aplicativo desenvolvido em parceira com a personal trainer Auxiliadora Silva, e como proposta de conclusão do curso de Ciência da Computação do Unifor MG pelo aluno Italo Cesar Castro!',
                              style:
                                  TextStyle(foreground: Paint(), fontSize: 14),
                            ),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                                // Code to execute.
                              },
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
        drawer: SafeArea(
          child: CollapsibleSidebar(
            items: menuItensNotAdmin(context, 'rankingPage'),
            textStyle: TextStyle(),
            avatarImg: AssetImage('assets/img/personGymProfile.png'),
            isCollapsed: false,
            title: 'Ola !',
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
                    const Padding(
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
                future: Provider.of<UserRepository>(context, listen: false)
                    .readAll(),
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
      ),
    );
  }

  RankingWidget(List<Usuario> lista) {
    lista.sort((a, b) => (b.pontuacao).compareTo((a.pontuacao)));
    loadImageProfile1(lista[0].uid);
    loadImageProfile2(lista[1].uid);
    loadImageProfile3(lista[3].uid);
    return Column(
      children: [
        topThree(lista[0], lista[1], lista[2]),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                borderOnForeground: true,
                shadowColor: Colors.black,
                elevation: 6,
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

  topThree(Usuario firstPlace, Usuario secondPlace, Usuario threePlace) {
    return Consumer<UserRepository>(builder: (context, repository, child) {
      return Card(
        elevation: 16,
        borderOnForeground: true,
        shadowColor: Colors.black,
        child: (Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      arquivos1 != ''
                          ? Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(arquivos1),
                                ),
                              ),
                            )
                          : Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/img/personGymProfile.png'),
                                ),
                              ),
                            ),
                      const Text(
                        '1° Lugar',
                      ),
                      Text(
                        firstPlace.nome,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 9.0, left: 20, right: 9.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      arquivos2 != ''
                          ? Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(arquivos2),
                                ),
                              ),
                            )
                          : Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/img/personGymProfile.png'),
                                ),
                              ),
                            ),
                      Text('2 ° Lugar'),
                      Text(threePlace.nome),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 113),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      arquivos3 != ''
                          ? Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(arquivos3),
                                ),
                              ),
                            )
                          : Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/img/personGymProfile.png'),
                                ),
                              ),
                            ),
                      const Text('3° Lugar'),
                      Text(threePlace.nome),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )),
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
