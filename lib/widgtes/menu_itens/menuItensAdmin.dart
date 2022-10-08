import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/model/Configurations.dart';
import 'package:ta_pago/service/auth_service.dart';
import 'package:ta_pago/widgtes/menu_itens/itens/RankingPage.dart';
import 'package:ta_pago/widgtes/menu_itens/itens/configuration_project.dart';
import 'package:ta_pago/widgtes/menu_itens/itens/viewVideos.dart';

import '../isAdmin.dart';
import 'itens/Diet.dart';

import 'itens/addVideos.dart';
import 'itens/alunos.dart';

menuItens(BuildContext context, String localization) {
  final List<CollapsibleItem> menuItens = [
    CollapsibleItem(
      isSelected: localization == 'viewVideos',
      text: 'Inicio',
      icon: Icons.home,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ViewVideos();
            },
          ),
        );
      },
    ),
    CollapsibleItem(
      isSelected: localization == 'addVideos',
      text: 'Adicionar Videos',
      icon: Icons.video_collection,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AddVideos();
            },
          ),
        );
      },
    ),
    CollapsibleItem(
        isSelected: localization == 'alunos',
        text: 'Alunos',
        icon: Icons.person_pin_sharp,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Alunos();
              },
            ),
          );
        }),
    //CollapsibleItem(text: 'Chat', icon: Icons.chat_outlined, onPressed: () {}),
    CollapsibleItem(
        isSelected: localization == 'rankingPage',
        text: 'Ranking',
        icon: Icons.add_chart,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return RankingPage();
              },
            ),
          );
        }),
    CollapsibleItem(
        isSelected: localization == 'diet',
        text: 'Dieta',
        icon: Icons.lunch_dining,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Diet();
              },
            ),
          );
        }),
    CollapsibleItem(
      isSelected: localization == 'configuration_project',
        text: 'Configurações',
        icon: Icons.settings,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const ConfigurationProject();
              },
            ),
          );
        }),
    CollapsibleItem(
        text: 'Sair',
        icon: Icons.exit_to_app,
        onPressed: () {
          Provider.of<AuthService>(context, listen: false).logout();
        }),
  ];
  return menuItens;
}
