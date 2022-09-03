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
  @override
  Widget build(BuildContext context) {
    Future<List<Usuario>> listUsers =
        Provider.of<UserRepository>(context, listen: false).readAll();

    return FutureBuilder(
      future: Provider.of<UserRepository>(context, listen: false).readAll(),
      builder: (BuildContext context, AsyncSnapshot<List<Usuario>> snapshot) {
        if (!snapshot.hasData)
          return Container(
            child: Text('Nenhum usurio encontrado'),
          ); // still loading
        else {
          return Teste(snapshot.data!);
        }
        // return a widget here (you have to return a widget to the builder)
      },
    );
  }

  Teste(List<Usuario> lista) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: SizedBox(
            width: 60,
            height: 40,
            child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/ta-pago-19987.appspot.com/o/VwBV7kWin8VWsA2HAD6MeQ22cf03.jpg?alt=media&token=97ed1b64-2875-49f9-bd57-a58bdf634516',
                //arquivos[INDEX]
                fit: BoxFit.cover),
          ),
          title: Text(''), //refs[index].fullPath
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => print('oi'), //deleteImage(index)
          ),
        );
      },
      itemCount: lista.length,
    );
  }

  CardUser(List<Usuario> usuario) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      child: Image.asset('assets/img/Medidas.jpeg'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(usuario[2].nome),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
