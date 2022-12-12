import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/model/Usuario.dart';
import 'package:ta_pago/widgtes/menu_itens/itens/videos.dart';
import '../../../repository/configurationRepository.dart';
import '../../../repository/userRepository.dart';
import '../../../service/connection.dart';
import '../menuItensAdmin.dart';
import '../menuItensNotAdmin.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ViewVideos extends StatefulWidget {
  const ViewVideos({Key? key}) : super(key: key);

  @override
  State<ViewVideos> createState() => _ViewVideosState();
}

class _ViewVideosState extends State<ViewVideos> {
  DateTime dataAtual = DateTime.now();
  int diaProjeto = 0;
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool uploading = false;
  double total = 0.0;
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadVideos();
  }

  @override
  Widget build(BuildContext context) {
    final usserLogged =
        Provider.of<UserRepository>(context, listen: true).usuarioLogado;
    Provider.of<ConfigurationRepository>(context, listen: true).readAll();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        shadowColor: Colors.black54,
        centerTitle: true,
        title: const Text(
          'Acelerando o seu emagrecimento!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: usserLogged.isAdmin
              ? menuItens(context, 'viewVideos')
              : menuItensNotAdmin(context, 'viewVideos'),
          textStyle: const TextStyle(),
          avatarImg: const AssetImage('assets/img/personGymProfile.png'),
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
      body: Consumer<ConfigurationRepository>(
        builder: (context, cfg, child) {
          if (cfg.cfgRepository.ativo &&
              cfg.cfgRepository.dataInicial.isNotEmpty &&
              cfg.cfgRepository.dataFinal.isNotEmpty) {
            var vetDataInicial = cfg.cfgRepository.dataInicial.split('/');
            if (vetDataInicial.isNotEmpty && vetDataInicial.length > 0) {
              DateTime dataInicio = DateTime(
                  int.tryParse(vetDataInicial[2].toString())!,
                  int.tryParse(vetDataInicial[1].toString())!,
                  int.tryParse(vetDataInicial[0].toString())!);
              diaProjeto = dataAtual.difference(dataInicio).inDays + 1;
            }
          }
          return (cfg.cfgRepository.ativo &&
                  cfg.cfgRepository.dataInicial.isNotEmpty &&
                  cfg.cfgRepository.dataFinal.isNotEmpty &&
                  diaProjeto <= 23
              ? ListView(
                  children: [
                    Container(
                        color: Colors.white10,
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shadowColor: Colors.orange,
                                  elevation: 25,
                                  color: Colors.white10,
                                  child: Text(
                                      'Hojé é o ${diaProjeto}° dia de projeto.',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: loading
                                    ? [
                                        Center(
                                          child: Column(
                                            children: const [
                                              Text('Carregando Videos'),
                                              CircularProgressIndicator(),
                                            ],
                                          ),
                                        )
                                      ]
                                    : listWidgets(diaProjeto, usserLogged),
                              ),
                            ],
                          ),
                        )),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        children: const [
                          Text(
                            'O Projeto não está ativo',
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            'Contate o administrador!',
                            style: TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
        },
      ),
    );
  }

  listWidgets(int diaProjeto, Usuario usserLogged) {
    List<Widget> listaWidgets = [];
    for (var x = 1; x <= diaProjeto; x++) {
      listaWidgets.add(
        Card(
          shadowColor: Colors.lightBlueAccent,
          elevation: 16,
          color: Colors.orange,
          child: Column(
            children: [
              Card(
                shadowColor: Colors.lightBlueAccent,
                elevation: 16,
                color: Colors.orange,
                child: Column(
                  children: [
                    Text(
                      '${x}° Dia ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    VideoApp(
                      arquivos[x].toString(),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Marcar ${x}° video como concluido'),
                  Checkbox(
                    value: usserLogged.listaVideosAssistidos[x - 1],
                    onChanged: (bool? value) {
                      marcarVideoAssitido(x, usserLogged);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return listaWidgets;
  }

  loadVideos() async {
    do {
      try {
        print('vou carregar os videos');

        refs = (await storage.ref('video').listAll()).items;
        print('foi encontrado ${refs.length} videos no banco de dados');
        if (arquivos.length < refs.length) {
          for (var ref in refs) {
            print("arquivos.lengt" + arquivos.length.toString());
            arquivos.add(await ref.getDownloadURL());
          }
        }
        setState(() {
          loading = false;
        });
      } catch (e) {
        setState(() {
          loading = false;
        });
        print('erro ao carregar videos' + e.toString());
      }
    } while (arquivos.length < diaProjeto);
  }

  marcarVideoAssitido(int index, Usuario user) async {
    try {
      verifyConnectivity();
      user.listaVideosAssistidos[index - 1] =
          !user.listaVideosAssistidos[index - 1];
      if (user.listaVideosAssistidos[index - 1]) {
        user.pontuacao += 1;
      } else {
        user.pontuacao -= 1;
      }

      await Provider.of<UserRepository>(context, listen: false).update(user);
      setState(() {});
      showToast(
        '${user.listaVideosAssistidos[index - 1] ? 'Parabéns por concluir mais um treino!!!' : 'Não deixe de assitir a esta aula.'}',
        //!user.ativo ? user.nome + ' Bloqueado' : user.nome + ' Liberado',
        context: context,
        backgroundColor: Colors.lightBlueAccent,
        position: StyledToastPosition.right,
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
    } catch (e) {
      showToast(
        'Ero ao fazer alteração no aluno.',
        context: context,
        backgroundColor: Colors.orange,
        position: StyledToastPosition.right,
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
      print('erro ao fazer atualizacao' + e.toString());
    }
  }

  verifyConnectivity() async {
    final conn = await Provider.of<Connection>(context, listen: false)
        .checkConnectivty();
    return conn.toString();
  }

  @override
  void dispose() {
    this.dispose();
    super.dispose();
  }
}
