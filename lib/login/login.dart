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
        "/login": (context) => Login(),
        "/homePage": (context) => HomePage()
      },
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        extendBody: true,
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Desafio 21 Dias!',
                textAlign: TextAlign.center,
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
                      padding: EdgeInsets.only(top: 150.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 25.0, left: 25.0),
                            child: TextFormField(
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
                                label: Text('E-mail'),
                                hintText: 'E-mail',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(25),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
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
                                      suffixIcon: IconButton(
                                        onPressed: () => setState(() {
                                          hidePassworld = !hidePassworld;
                                        }),
                                        icon: Icon(Icons.remove_red_eye),
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
                              onPressed: () {
                                login(context);
                              },
                              child: loading
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      'Entrar',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                            ),
                          ),
                          TextButton(
                            child: const Text('Não tem cadastro? Cadastre-se'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    print('vou navegar');
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
            backgroundColor: Colors.white70,
            splashColor: Colors.blue,
            onPressed: () {
              _messangerKey.currentState?.showSnackBar(
                SnackBar(
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
            setState(() {
              loading = false;
            });
            Navigator.popAndPushNamed(
              contextParam,
              '/homePage',
            );
          } else {
            setState(() {
              loading = false;
            });
            showToast(
              'Usuário inativo, favor contate o administrador!',
              context: contextParam,
              textStyle: TextStyle(foreground: Paint()),
              backgroundColor: Colors.red,
              position: StyledToastPosition.bottom,
              duration: const Duration(seconds: 5),
              curve: Curves.elasticInOut,
              animDuration: const Duration(seconds: 2),
              animation: StyledToastAnimation.fadeScale,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            );

            /*_messangerKey.currentState?.showSnackBar(
              SnackBar(
                content:
                    Text('Usuário inativo, favor contate o administrador!'),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {
                    // Code to execute.
                  },
                ),
              ),
            );*/
          }
        }
      } on AuthException catch (e) {
        setState(() {
          loading = false;
        });
        showToast('${e.message}',
            context: contextParam,
            textStyle: TextStyle(foreground: Paint()),
            backgroundColor: Colors.red,
            position: StyledToastPosition.bottom,
            duration: const Duration(seconds: 5),
            curve: Curves.elasticInOut,
            animDuration: const Duration(seconds: 2),
            animation: StyledToastAnimation.fadeScale,
            borderRadius: BorderRadius.all(Radius.circular(12)));
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
