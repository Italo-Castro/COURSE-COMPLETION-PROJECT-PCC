import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';

import 'isAdmin.dart';
import 'menu_itens/Diet.dart';
import 'menu_itens/addVideos.dart';
import 'menu_itens/alunos.dart';

menuItens(BuildContext context, String localization) {
  final List<CollapsibleItem> menuItens = [
    CollapsibleItem(
      isSelected: localization == 'isAdmin',
      text: 'Inicio',
      icon: Icons.home,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return isAdmin();
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
    CollapsibleItem(text: 'Chat', icon: Icons.chat_outlined, onPressed: () {}),
    CollapsibleItem(text: 'Ranking', icon: Icons.add_chart, onPressed: () {}),
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
        text: 'Configurações', icon: Icons.settings, onPressed: () {}),
  ];
  return menuItens;
}
