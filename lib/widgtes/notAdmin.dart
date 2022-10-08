import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repository/userRepository.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'menu_itens/menuItensAdmin.dart';
import 'menu_itens/menuItensNotAdmin.dart';

class NotAdmin extends StatefulWidget {
  @override
  State<NotAdmin> createState() => _NotAdminState();
}

class _NotAdminState extends State<NotAdmin> {
  List<Reference> refs = [];
  List<String> arquivos = [];
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    final usserLogged =
        Provider.of<UserRepository>(context, listen: false).usuarioLogado;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem vindo ao projeto!'),
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: usserLogged.isAdmin
              ? menuItens(context, 'rankingPage')
              : menuItensNotAdmin(context, 'rankingPage'),
          textStyle: TextStyle(),
          avatarImg: AssetImage('assets/img/personGymProfile.png'),
          isCollapsed: false,
          title: 'Ola !',
          titleStyle: TextStyle(
            fontSize: 22,
          ),
          toggleTitleStyle: TextStyle(),
          toggleTitle: ('Esconder'),
          body: Container(),
        ),
      ),
    );
  }
}
