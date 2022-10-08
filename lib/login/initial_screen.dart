import 'package:flutter/material.dart';
import 'package:ta_pago/login/login.dart';
import 'package:ta_pago/login/register_user.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SingleChildScrollView(
        child: Container(
          //Image.asset('assets/fundo/Fundo2.jpg'),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/fundo/Fundo2.jpg',
                ),
                fit: BoxFit.fill),
          ),
          child: Column(children: [
            Builder(
              builder: (context) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(55),
                            child: Container(
                              width: 280,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Builder(
                                builder: (context) =>
                                    ElevatedButton(
                                      child: const Text('Entrar'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                               return const Login();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            width: 280,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              child: const Text('Cadastrar'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return RegisterUser();
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            ),
          ]),
        ),
      ),
    );
  }
}
