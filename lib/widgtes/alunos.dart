import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Usuario.dart';
import '../repository/userRepository.dart';

class Alunos extends StatefulWidget {
  const Alunos({Key? key}) : super(key: key);

  @override
  State<Alunos> createState() => _AlunosState();
}

class _AlunosState extends State<Alunos> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserRepository>(context, listen: false).readAll(),
      builder: (BuildContext context, AsyncSnapshot<List<Usuario>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: const Text('Nenhum aluno encontrado'),
          ); // still loading
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: UserWidget(snapshot.data!),
            ),
          );
        }
        // return a widget here (you have to return a widget to the builder)
      },
    );
  }

  UserWidget(List<Usuario> lista) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: SizedBox(
            width: 60,
            height: 40,
            child: arquivos.isEmpty
                ? Image.asset(
                    'assets/img/personGymProfile.png',
                  )
                : Image.network(arquivos[index]),
          ),
          title: Text(lista[index].nome), //refs[index].fullPath
          trailing: Checkbox(
            value: lista[index].ativo,
            onChanged: (bool? value) {
              userInactivate(lista[index]);
            },
          ),
        );
      },
      itemCount: lista.length,
    );
  }

  userInactivate(Usuario user) async {
    print('vou inativar' + user.nome);
    user.ativo = !user.ativo;
    await Provider.of<UserRepository>(context, listen: false)
        .inactivateUser(user);
    setState(() {});

    _messangerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Oi'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Code to execute.
          },
        ),
      ),
    );
  }

  loadImages() async {
    List<Usuario> listUsers =
        await Provider.of<UserRepository>(context, listen: false).readAll();

    for (var x = 0; x < listUsers.length; x++) {
      refs = (await storage.ref('${listUsers[x].uid}/').listAll()).items;
      for (var ref in refs) {
        arquivos.add(await ref.getDownloadURL());
      }
    }
    setState(() {
      loading = false;
    });
  }
}
