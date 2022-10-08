import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repository/userRepository.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'menu_itens/menuItensAdmin.dart';
import 'menu_itens/menuItensNotAdmin.dart';

class isAdmin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final usserLogged =
        Provider.of<UserRepository>(context, listen: false).usuarioLogado;
    return Scaffold(
      appBar: AppBar(
        title: Text('Desafio 21 Dias!'),
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: usserLogged.isAdmin
              ? menuItens(context, 'viewVideos')
              : menuItensNotAdmin(context, 'viewVideos'),
          textStyle: TextStyle(),
          avatarImg: AssetImage('assets/img/personGymProfile.png'),
          isCollapsed: false,
          title:
              'Ola ${Provider.of<UserRepository>(context, listen: true).usuarioLogado.nome}!',
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
