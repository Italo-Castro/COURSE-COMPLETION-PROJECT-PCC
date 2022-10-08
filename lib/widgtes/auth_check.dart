import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/login/initial_screen.dart';
import 'package:ta_pago/repository/userRepository.dart';
import 'package:ta_pago/widgtes/homePage.dart';

import '../login/login.dart';
import '../service/auth_service.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    UserRepository user = Provider.of<UserRepository>(context, listen: true);

    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null || user.usuarioLogado.email == 'email') {
      return const Login();
    } else {
      return const HomePage();
    }
  }

  loading() {
    return MaterialApp(
      home: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(),
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 80, bottom: 250),
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
