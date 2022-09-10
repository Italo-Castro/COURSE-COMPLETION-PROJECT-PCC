import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repository/userRepository.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'menuItens.dart';

class isAdmin extends StatelessWidget {
  List<Reference> refs = [];
  List<String> arquivos = [];
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {

    final usserLogged =
        Provider.of<UserRepository>(context, listen: false).usuarioLogado;
    loadImages(usserLogged.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem vindo ao projeto!'),
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: menuItens(context, 'isAdmin'),
          textStyle: TextStyle(),
          avatarImg: arquivos.isEmpty
              ? AssetImage('assets/img/personGymProfile.png')
              : NetworkImage(arquivos[0]),
          isCollapsed: false,
          title: 'Ola ${usserLogged.nome}!',
          titleStyle: TextStyle(
            fontSize: 22,
          ),
          toggleTitleStyle: TextStyle(),
          toggleTitle: ('LESS'),
          body: Container(),
        ),
      ),
    );
  }

  loadImages(String uidUsserLogged) async {
    refs = (await storage.ref('${uidUsserLogged}/').listAll()).items;
    for (var ref in refs) {
      arquivos.add(await ref.getDownloadURL());
    }
    print('arquivos lengh' + arquivos.length.toString());
  }
}
