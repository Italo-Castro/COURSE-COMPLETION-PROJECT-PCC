
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../repository/userRepository.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import '../menuItensAdmin.dart';
import '../menuItensNotAdmin.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'dart:io';

class Diet extends StatefulWidget {
  const Diet({Key? key}) : super(key: key);

  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  List<Reference> refs = [];
  List<String> arquivos = [];
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool uploading = false;
  double total = 0.0;
  bool loading = false;
  double progress = 0;
  String _localPath = '';

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
        title: const Text(
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
          textStyle: const TextStyle(),
          avatarImg: arquivos.isEmpty
              ? const AssetImage('assets/img/personGymProfile.png')
              : NetworkImage(arquivos[0]),
          isCollapsed: false,
          title: 'Ola ${usserLogged.nome}!',
          titleStyle: const TextStyle(
            fontSize: 22,
          ),
          toggleTitleStyle: const TextStyle(),
          toggleTitle: ('Esconder'),
          body: Container(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(28.0),
              child: Card(
                elevation: 21,
                child: Text('Siga a dieta durante os 21 dias!',
                    style: TextStyle(color: Colors.black, fontSize: 22)),
              ),
            ),
            Center(
              child: usserLogged.isAdmin
                  ? Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            getFile();
                          },
                          child: uploading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text('Postar Arquivo Dieta!'),
                        ),
                        ElevatedButton(
                          onPressed: () => dowloadFile(),
                          child: Text('Baixar Arquivo Dieta!'),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {},
                      child: Text('Baixar Arquivo Dieta!'),
                    ),
            ),
            SizedBox(
              width: 300,
              child: LinearProgressIndicator(
                backgroundColor: Colors.orange,
                color: Colors.white,
                value: total,
                semanticsLabel: 'Linear progress indicator',
              ),
            ),
          ],
        ),
      ),
    );
  }

  getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      await this.upload(file);
    } else {
      print('User canceled the picker');
      // User canceled the picker
    }
  }

  upload(File file) async {
    //File file = File(path);
    arquivos = [];
    try {
      setState(() {
        loading = true;
      });
      //ref local que vai ser savlo
      String ref = 'dieta';
      setState(() {
        loading = false;
      });
      storage.ref(ref).putFile(file).then((result) => {
            setState(() {
              uploading = true;
              total = (result.bytesTransferred / result.totalBytes) * 100;
            })
          });

      if (total == 100) {
        setState(() {
          uploading = false;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arquivo enviado para o banco de dados!')));
    } on FirebaseException catch (e) {
      showToast(
        'Erro ao enviar arquivo',
        context: context,
        backgroundColor: Colors.red,
        position: StyledToastPosition.bottom,
        animation: StyledToastAnimation.slideFromRight,
        alignment: const Alignment(50, 0),
        textStyle: TextStyle(foreground: Paint()),
        toastHorizontalMargin: 12,
        isHideKeyboard: true,
        reverseCurve: Curves.fastLinearToSlowEaseIn,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 3),
        curve: Curves.fastLinearToSlowEaseIn,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      );

      print("deu erro para upar arquivo dieta");
      throw Exception('Erro ao fazer upload : ${e.toString()}');
    }
  }

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory?.path ?? 'DOWLOADS';
  }

  dowloadFile() async {
    var x = (await storage.ref('dieta').getDownloadURL());
    print('path file diet' + x.toString());
    var url = x;

    for (var ref in refs) {
      url = await ref.getDownloadURL();
    }
    if (x.isNotEmpty) {
      _localPath = (await _findLocalPath()) + '/Download';
      final savedDir = Directory(_localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }

    /*  final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: _localPath,
        showNotification: true,
        // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );*/
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Arquivo da dieta baixado com sucesso...')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Não foi encontrado nada no banco de dados!')));
    }
  }
}
