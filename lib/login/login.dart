// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/login/register_user.dart';
import 'package:ta_pago/service/connection.dart';
import '../repository/userRepository.dart';
import '../service/auth_service.dart';
import '../widgtes/homePage.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passworldController = TextEditingController();
  bool loading = false;
  bool hidePassworld = true;
  final formKey = GlobalKey<FormState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //rotas nomeadas
      routes: {
        "/login": (context) => const Login(),
        "/homePage": (context) => const HomePage()
      },
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          shadowColor: Colors.blueAccent,
          elevation: 10,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text(
                'Desafio 21 Dias!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 150.0),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 25.0, left: 25.0),
                            child: TextFormField(
                              toolbarOptions: ToolbarOptions(
                                selectAll: true,
                              ),
                              textAlign: TextAlign.center,
                              controller: _emailController,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Por favor informar e-mail';
                                }
                                if (value != null && value.contains(' ')) {
                                  return 'Seu email pode ter algum espaço em branco, CONFIRA!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: const Text('E-mail'),
                                hintText: 'E-mail',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    toolbarOptions: ToolbarOptions(
                                      selectAll: true,
                                    ),
                                    maxLength: 6,
                                    textAlign: TextAlign.center,
                                    obscureText: hidePassworld,
                                    controller: _passworldController,
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return 'Por favor informar senha';
                                      }
                                      if (value!.length < 6) {
                                        return 'A senha precisa ter 6 caracteres';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      errorBorder: InputBorder.none,
                                      suffixIcon: IconButton(
                                        onPressed: () => setState(() {
                                          hidePassworld = !hidePassworld;
                                        }),
                                        icon: const Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      label: Text('Senha'),
                                      hintText: 'Senha',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 280,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.resolveWith(
                                      (states) => 2),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.white),
                                  shadowColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.blueAccent)),
                              onPressed: () {
                                login(context);
                              },
                              child: loading
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 1,
                                      color: Colors.orange,
                                    )
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 18),
                                    ),
                            ),
                          ),
                          TextButton(
                            child: const Text(
                              'Não tem cadastro? Cadastre-se aqui!',
                              style: TextStyle(fontSize: 15),
                            ),
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
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orangeAccent,
            splashColor: Colors.yellowAccent,
            onPressed: () {
              _messangerKey.currentState?.showSnackBar(
                SnackBar(
                  dismissDirection: DismissDirection.down,
                  backgroundColor: Colors.white70,
                  content: Text(
                    'Aplicativo desenvolvido em parceira com a personal trainer Auxiliadora Silva, e como proposta de conclusão do curso de Ciência da Computação do Unifor MG pelo aluno Italo Cesar Castro!',
                    style: TextStyle(foreground: Paint(), fontSize: 14),
                  ),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
            },
            mini: true,
            child: Container(
              child: Icon(Icons.question_mark),
            )),
      ),
    );
  }

  login(BuildContext contextParam) async {
    final conectivity = await context.read<Connection>().checkConnectivty();
    if (conectivity == 'Your mobile is no Internet Connection') {
      showToast(
        'Você parece estar sem internet, verifique sua conexão!!',
        context: contextParam,
        position: const StyledToastPosition(align: Alignment.topRight),
        textStyle: TextStyle(foreground: Paint()),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        curve: Curves.elasticInOut,
        animDuration: const Duration(seconds: 2),
        animation: StyledToastAnimation.fadeScale,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      );
    }
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          loading = true;
        });

        //faz o login
        await context.read<AuthService>().login(
            _emailController.text.trim(), _passworldController.text.trim());

        //carega o usuario
        await context.read<UserRepository>().readUser(
            Provider.of<AuthService>(context, listen: false).usuario!.uid);

        final usuarioLogado =
            Provider.of<UserRepository>(context, listen: false).usuarioLogado;
        if (usuarioLogado != null) {
          if (usuarioLogado.ativo) {
            Navigator.popAndPushNamed(
              contextParam,
              '/homePage',
            );
            setState(() {
              loading = false;
            });
          } else if (!usuarioLogado.ativo) {
            setState(() {
              loading = false;
            });
            print('usuario na tela de login' + usuarioLogado.toString());
            showToast(
              'Usuário inativo, favor contate o administrador!',
              context: contextParam,
              position: const StyledToastPosition(
                  align: Alignment.topRight, offset: 70),
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
      } on AuthException catch (e) {
        setState(() {
          loading = false;
        });
        showToast(
          '${e.message} !',
          context: contextParam,
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
        /*_messangerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.message}'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                // Code to execute.
              },
            ),
          ),
        );*/
        print('deu erro' + e.message);
      }
    }
  }
}
