import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Storage extends ChangeNotifier {
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool uploading = false;
  double total = 0.0;
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = true;

  loadImages() async {
    refs = (await storage.ref('usersProfile').listAll()).items;
    for (var ref in refs) {
      arquivos.add(await ref.getDownloadURL());
    }
  }

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<UploadTask> upload(String path, String uid) async {
    File file = File(path);

    try {
      //ref local que vai ser savlo
      String ref = '${uid}.jpg';
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro o upload : ${e.message}');
    }
  }

  pickAndUploadImage(String uid) async {
    XFile? file = await getImage();
    if (file != null) {
      UploadTask task = await upload(file.path, uid);
    }
  }

  deleteImage(int index) async {
    await storage.ref(refs[index].fullPath).delete();
    arquivos.removeAt(index);
    refs.removeAt(index);
  }
}
