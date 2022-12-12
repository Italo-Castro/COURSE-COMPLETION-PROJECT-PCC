import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/widgtes/isAdmin.dart';
import 'package:ta_pago/widgtes/notAdmin.dart';

import '../repository/userRepository.dart';
import 'menu_itens/itens/viewVideos.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ViewVideos(),
      //usserLogged.isAdmin ? ViewVideos() : NotAdmin(),
    );
  }
}
