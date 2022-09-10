import 'dart:io';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../repository/userRepository.dart';
import '../isAdmin.dart';
import '../menuItens.dart';

class AddVideos extends StatefulWidget {
  const AddVideos({Key? key}) : super(key: key);

  @override
  State<AddVideos> createState() => _AddVideosState();
}

class _AddVideosState extends State<AddVideos> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool uploading = false;
  double total = 0.0;
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadVideos();
  }

  @override
  Widget build(BuildContext context) {

    final usserLogged =
        Provider.of<UserRepository>(context, listen: false).usuarioLogado;
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicione os videos'),
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: menuItens(context, 'addVideos'),
          textStyle: TextStyle(),
          avatarImg: AssetImage('assets/img/personGymProfile.png'),
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
      body: SingleChildScrollView(
        child: Column(children: listWidgets()),
      ),
    );
  }

  listWidgets() {
    List<Widget> listaWidgets = [];
    for (var x = 1; x < 22; x++) {
      listaWidgets.add(
        Column(
          children: [
            loading
                ? CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            'assets/img/Medidas.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteVideo(x);
                        },
                        icon: Icon(Icons.delete_forever),
                      ),
                    ],
                  ),
            Container(
              width: 125,
              child: ElevatedButton(
                style: ButtonStyle(),
                onPressed: () {
                  pickAndUploadImage(x);
                },
                child: Row(
                  children: [Icon(Icons.add), Text('${x}°Video')],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return listaWidgets;
  }

  loadVideos() async {
    refs = (await storage.ref('video').listAll()).items;
    loading = true;
    for (var ref in refs) {
      arquivos.add(await ref.getDownloadURL());
    }
    setState(() {
      loading = false;
    });
    print('tenho' + arquivos.length.toString() + ' videos');
  }

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickVideo(source: ImageSource.gallery);
    return image;
  }

  Future<UploadTask> upload(String path, int index) async {
    File file = File(path);

    try {
      //ref local que vai ser savlo
      String ref = 'video/${index}.mp4';
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro o upload : ${e.message}');
    }
  }

  pickAndUploadImage(int index) async {
    XFile? file = await getImage();
    if (file != null) {
      UploadTask task = await upload(file.path, index);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            uploading = true;
            total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        } else if (snapshot.state == TaskState.success) {
          arquivos.add(await snapshot.ref.getDownloadURL());
          refs.add(snapshot.ref);
          setState(() {
            uploading = false;
          });
        }
        ;
      });
    }
  }

  deleteVideo(int index) async {
    print('tenho' + refs.length.toString() + 'referencias');
    print('vou deletar o video' + index.toString());
    await storage.ref(refs[index].fullPath).delete();
    arquivos.removeAt(index);
    refs.removeAt(index);
    loadVideos();
    setState(() {});
  }
}
/*
Column(
      children: [
        listWidgets(),
        Row(
          children: [
            Container(
              child: Image.asset(
                'assets/img/Medidas.jpeg',
                width: 50,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete_forever),
            ),
          ],
        ),
        ElevatedButton(
          style: ButtonStyle(),
          onPressed: () {},
          child: Row(
            children: [Icon(Icons.add), Text('1°Video')],
          ),
        ),
      ],
    );
 */
