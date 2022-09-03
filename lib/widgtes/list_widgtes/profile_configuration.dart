import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../model/Usuario.dart';
import '../../repository/userRepository.dart';

class ProfileConfigurations extends StatefulWidget {
  const ProfileConfigurations({Key? key}) : super(key: key);

  @override
  State<ProfileConfigurations> createState() => _ProfileConfigurationsState();
}

class _ProfileConfigurationsState extends State<ProfileConfigurations> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool uploading = false;
  double total = 0.0;
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = false;
  String urlImageProfile = '';
  final _appEvaluation = TextEditingController();
  final _nickName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usserLogged =
        Provider.of<UserRepository>(context, listen: false).usuarioLogado;


    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadImages(usserLogged.uid);
      _appEvaluation.text = usserLogged.avaliacaoApp.toString();
      _nickName.text = usserLogged.apelido.toString();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ola! ${usserLogged.nome}',
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5, right: 8.0, left: 8),
              child: Card(
                child: Text(
                    'Até agora você conquistou ${usserLogged.pontuacao} pontos'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, right: 8.0, left: 8),
              child: TextFormField(
                controller: _nickName,
                decoration: InputDecoration(
                  labelText: 'Apelido',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 8.0, left: 8),
              child: TextFormField(
                controller: _appEvaluation,
                decoration: InputDecoration(
                  labelText: 'Nota do aplicativo 0 - 5',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 8.0, left: 8),
              child: Container(
                width: 280,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    pickAndUploadImage(usserLogged.uid);
                  },
                  child: Text('Atualizar Foto'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 8.0, left: 8),
              child: Container(
                child: loading | uploading
                    ? Column(
                        children: [
                          Text('${total.round()}% enviado'),
                          CircularProgressIndicator(),
                        ],
                      )
                    : arquivos.isEmpty
                        ? Container(
                            width: 190.0,
                            height: 190.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    'assets/img/personGymProfile.png'),
                              ),
                            ),
                          )
                        : Container(
                            width: 190.0,
                            height: 190.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(arquivos[0]),
                              ),
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveUser(usserLogged);
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.white70,
        splashColor: Colors.red,
      ),
    );
  }

  saveUser(Usuario usserLooged) {
    usserLooged.apelido = _nickName.text;
    usserLooged.avaliacaoApp = int.tryParse(_appEvaluation.text);
    Provider.of<UserRepository>(context, listen: false).update(usserLooged);
  }

  loadImages(String uidUsserLogged) async {
    refs = (await storage.ref('${uidUsserLogged}/').listAll()).items;
    for (var ref in refs) {
      arquivos.add(await ref.getDownloadURL());
    }
    print('arquivos lengh' + arquivos.length.toString());
  setState(() {
    loading = false;
  });
  }

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<UploadTask> upload(String path, String uidUsserLogged) async {
    File file = File(path);
    arquivos = [];
    try {
      setState(() {
        loading = true;
      });
      //ref local que vai ser savlo
      String ref = '${uidUsserLogged}/${uidUsserLogged}.jpg';
      setState(() {
        loading = false;
      });
      return storage.ref(ref).putFile(file);

      print('imagem salva');
    } on FirebaseException catch (e) {
      print("deu erro para upar foto");
      throw Exception('Erro o upload : ${e.message}');
    }
  }

  pickAndUploadImage(String uidUsserLogged) async {
    XFile? file = await getImage();
    if (file != null) {
      UploadTask task = await upload(file.path, uidUsserLogged);
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
}

/*
deleteImage(int index) async {
    await storage.ref(refs[index].fullPath).delete();
    arquivos.removeAt(index);
    refs.removeAt(index);
    setState(() {});
  }
  loadImages() async {
    refs = (await storage.ref('image').listAll()).items;
    for (var ref in refs) {
      arquivos.add(await ref.getDownloadURL());
    }
    setState(() {
      loading = false;
    });
  }
*/
