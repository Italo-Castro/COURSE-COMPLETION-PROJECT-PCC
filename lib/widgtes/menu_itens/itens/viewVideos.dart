import 'dart:io';

import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/widgtes/menu_itens/itens/videos.dart';

import '../../../repository/configurationRepository.dart';
import '../../../repository/userRepository.dart';
import '../menuItensAdmin.dart';
import '../menuItensNotAdmin.dart';

class ViewVideos extends StatefulWidget {
  const ViewVideos({Key? key}) : super(key: key);

  @override
  State<ViewVideos> createState() => _ViewVideosState();
}

class _ViewVideosState extends State<ViewVideos> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool uploading = false;
  double total = 0.0;
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = true;
  DateTime dataAtual = DateTime.now();
  String diaProjeto = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usserLogged =
        Provider.of<UserRepository>(context, listen: true).usuarioLogado;
    Provider.of<ConfigurationRepository>(context, listen: true).readAll();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Desafio dos 21 Dias!',
        ),
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: usserLogged.isAdmin
              ? menuItens(context, 'viewVideos')
              : menuItensNotAdmin(context, 'viewVideos'),
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
      body: Consumer<ConfigurationRepository>(builder: (context, cfg, child) {
        /*  var vetDataInicial = cfg.cfgRepository.dataInicial.split('/');

        DateTime dataInicio = DateTime(
            int.tryParse(vetDataInicial[2].toString())!,
            int.tryParse(vetDataInicial[1].toString())!,
            int.tryParse(vetDataInicial[0].toString())!);
        diaProjeto = dataAtual.difference(dataInicio).inDays.toString();*/
        return (cfg.cfgRepository.ativo
            ? ListView(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Card(
                          child: Text('Hojé é o ${1}° dia de proejto.'),
                        ),

                        /*Column(
                          children: listWidgets(),
                        )*/
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                       const Text(
                          'O Projeto não está ativo',
                          style: TextStyle( fontSize: 22),
                        ),Text(
                          'Contate o administrador!',
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
      }),
    );
  }

  listWidgets() {
    List<Widget> listaWidgets = [];
    for (var x = 1; x < 22; x++) {
      listaWidgets.add(
        Card(
          color: Colors.lightBlue,
          child: VideoApp(
              'https://firebasestorage.googleapis.com/v0/b/ta-pago-19987.appspot.com/o/video%2F11.mp4?alt=media&token=a1c8f67f-784d-4854-a2c9-03813a7374ed'),
        ),
      );
    }

    return listaWidgets;
  }

  loadVideos() async {
    refs = (await storage.ref('video').listAll()).items;
    loading = true;
    print('foi encontrado ${refs.length} videos no banco de dados');
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
    try {
      Reference? ref;
      for (var x = 0; x < refs.length; x++) {
        if (refs[x].fullPath == 'video/${index}.mp4') {
          ref = refs[x];
          arquivos.removeAt(x);
          refs.removeAt(x);
        }
      }
      if (refs.contains(ref)) {
        print('posso deletar o arquivo${index}');
        await storage.ref(ref!.fullPath).delete();
        //arquivos.removeAt(index);
        //refs.removeAt(index);
        loadVideos();

        showToast('Video de numero${index} deletado com sucesso.',
            context: context,
            alignment: const Alignment(50, 0),
            textStyle: TextStyle(foreground: Paint()),
            backgroundColor: Colors.green,
            position: StyledToastPosition.bottom,
            duration: const Duration(seconds: 5),
            curve: Curves.fastLinearToSlowEaseIn,
            animDuration: const Duration(seconds: 2),
            animation: StyledToastAnimation.slideFromRight,
            reverseCurve: Curves.fastLinearToSlowEaseIn,
            borderRadius: BorderRadius.all(Radius.circular(12)));
      } else {
        showToast(
          'Video de numero ${index} não existe no banco  de dados \n Impossvel deletar.',
          context: context,
          textStyle: TextStyle(foreground: Paint()),
          backgroundColor: Colors.red,
          position: const StyledToastPosition(align: Alignment.topRight),
          duration: const Duration(seconds: 5),
          curve: Curves.fastLinearToSlowEaseIn,
          animDuration: const Duration(seconds: 2),
          animation: StyledToastAnimation.slideFromRight,
          reverseCurve: Curves.fastLinearToSlowEaseIn,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        );
      }
    } catch (e) {
      showToast(
        'Video de numero ${index} não existe no banco  de dados \n Impossvel deletar.',
        context: context,
        textStyle: TextStyle(foreground: Paint()),
        backgroundColor: Colors.red,
        position: const StyledToastPosition(align: Alignment.topRight),
        duration: const Duration(seconds: 5),
        curve: Curves.fastLinearToSlowEaseIn,
        animDuration: const Duration(seconds: 2),
        animation: StyledToastAnimation.slideFromRight,
        reverseCurve: Curves.fastLinearToSlowEaseIn,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      );
      print('erro ao deletar video numero ${index}' + e.toString());
    }
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
