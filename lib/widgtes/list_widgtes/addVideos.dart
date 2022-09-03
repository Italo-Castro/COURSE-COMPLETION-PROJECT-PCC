import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    return ListView(
      children: listWidgets(),
    );
  }

  listWidgets() {
    List<Widget> listaWidgets = [];
    for (var x = 1; x < 22; x++) {
      listaWidgets.add(
        Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    deleteVideo(x);
                  },
                  icon: Icon(Icons.delete_forever),
                ),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(),
              onPressed: () {
                pickAndUploadImage(x);
              },
              child: Row(
                children: [Icon(Icons.add), Text('${x}°Video')],
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
    for (var ref in refs) {
      arquivos.add(await ref.getDownloadURL());
    }
    setState(() {
      loading = false;
    });
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
    print('vou deletar o video' + index.toString());
    await storage.ref(refs[index].fullPath).delete();
    arquivos.removeAt(index);
    refs.removeAt(index);
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
