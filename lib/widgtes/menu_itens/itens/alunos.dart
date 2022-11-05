import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/service/connection.dart';
import '../../../model/Usuario.dart';
import '../../../repository/userRepository.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import '../menuItensAdmin.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../menuItensNotAdmin.dart';

class Alunos extends StatefulWidget {
  const Alunos({Key? key}) : super(key: key);

  @override
  State<Alunos> createState() => _AlunosState();
}

class _AlunosState extends State<Alunos> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loadImages();
    verifyConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final usserLogged =
        Provider.of<UserRepository>(context, listen: true).usuarioLogado;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        shadowColor: Colors.black54,
        centerTitle: true,
        title: Text(
          'Alunos Cadastrados!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: usserLogged.isAdmin
              ? menuItens(context, 'alunos')
              : menuItensNotAdmin(context, 'alunos'),
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
                      child: UserWidget(snapshot.data!),
                    ),
                  );
                }
                // return a widget here (you have to return a widget to the builder)
              },
            ),
    );
  }

  UserWidget(List<Usuario> lista) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Card(
          shadowColor: Colors.orange,
          elevation: 2,
          child: ListTile(
            leading: SizedBox(
              width: 60,
              height: 40,
              child: loading
                  ? Container(
                      width: 1,
                      height: 1,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ))
                  : arquivos.isEmpty
                      ? Image.asset(
                          'assets/img/personGymProfile.png',
                        )
                      : Image.network(''),
            ),
            title: Text(lista[index].nome), //refs[index].fullPath
            trailing: Checkbox(
              value: lista[index].ativo,
              onChanged: (bool? value) {
                userInactivate(lista[index]);
              },
            ),
          ),
        );
      },
      itemCount: lista.length,
    );
  }

  userInactivate(Usuario user) async {
    try {
      verifyConnectivity();

      print('vou inativar' + user.nome);
      user.ativo = !user.ativo;
      await Provider.of<UserRepository>(context, listen: false)
          .inactivateUser(user);
      setState(() {});
      showToast(
        !user.ativo ? user.nome + ' Bloqueado' : user.nome + ' Liberado',
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

  loadImages() async {
    try {
      List<Usuario> listUsers =
          await Provider.of<UserRepository>(context, listen: false).readAll();

      for (var x = 0; x < listUsers.length; x++) {
        refs = (await storage.ref('${listUsers[x].uid}/').listAll()).items;
        for (var ref in refs) {
          arquivos.add(await ref.getDownloadURL());
        }
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      showToast(
        'Ero ao fazer caregar imagens.',
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
    }
  }

  verifyConnectivity() async {
    final conn = await Provider.of<Connection>(context, listen: false)
        .checkConnectivty();
    return conn.toString();
  }
}
