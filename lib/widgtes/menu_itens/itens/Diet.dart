import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../repository/userRepository.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import '../menuItensAdmin.dart';
import '../menuItensNotAdmin.dart';

class Diet extends StatefulWidget {
  const Diet({Key? key}) : super(key: key);

  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  List<Reference> refs = [];
  List<String> arquivos = [];
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    final usserLogged =
        Provider.of<UserRepository>(context, listen: true).usuarioLogado;
    // loadImages(usserLogged.uid);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        shadowColor: Colors.black54,
        centerTitle: true,
        title: Text(
          'Dieta',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: usserLogged.isAdmin
              ? menuItens(context, 'diet')
              : menuItensNotAdmin(context, 'diet'),
          textStyle: TextStyle(),
          avatarImg: arquivos.isEmpty
              ? AssetImage('assets/img/personGymProfile.png')
              : NetworkImage(arquivos[0]),
          isCollapsed: false,
          title: 'Ola ${usserLogged.nome}!',
          titleStyle: TextStyle(
            fontSize: 22,
          ),
          toggleTitleStyle: TextStyle(),
          toggleTitle: ('Esconder'),
          body: Container(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: const Card(
                child: const Text('Siga a dieta durante os 21 dias!',
                    style: TextStyle(color: Colors.redAccent, fontSize: 22)),
                elevation: 21,
              ),
            ),
            Center(
              child: usserLogged.isAdmin
                  ? Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {}, child: Text('Postar Arquivo Dieta!'),),
                      ElevatedButton(
                        onPressed: () {}, child: Text('Baixar Arquivo Dieta!'),),
                    ],
                  )
                  : ElevatedButton(
                      onPressed: () {}, child: Text('Baixar Arquivo Dieta!'),),
            ),

          ],
        ),
      ),
    );
  }

// loadImages(String uidUsserLogged) async {
//   refs = (await storage.ref('${uidUsserLogged}/').listAll()).items;
//   for (var ref in refs) {
//     arquivos.add(await ref.getDownloadURL());
//   }
// }
}
