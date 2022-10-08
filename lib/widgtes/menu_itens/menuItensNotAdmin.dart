import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/service/auth_service.dart';
import 'package:ta_pago/widgtes/menu_itens/itens/RankingPage.dart';
import 'package:ta_pago/widgtes/menu_itens/itens/profile_configuration.dart';
import 'package:ta_pago/widgtes/menu_itens/itens/viewVideos.dart';
import 'itens/Diet.dart';
import 'itens/configuration_project.dart';

menuItensNotAdmin(BuildContext context, String localization) {
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
        isSelected: localization == 'profileConfiguration',
        text: 'Configurações',
        icon: Icons.settings,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const ProfileConfigurations();
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
