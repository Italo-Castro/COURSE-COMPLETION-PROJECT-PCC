import 'dart:io';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../../repository/userRepository.dart';
import '../menuItensAdmin.dart';
import '../menuItensNotAdmin.dart';

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
        Provider.of<UserRepository>(context, listen: true).usuarioLogado;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        shadowColor: Colors.black54,
        centerTitle: true,
        title: Text(
          'Adicionar videos',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: usserLogged.isAdmin
              ? menuItens(context, 'addVideos')
              : menuItensNotAdmin(context, 'addVideos'),
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: loading
                ? [
                    Text(
                      'Aguarde carregando videos ... ',
                      style: TextStyle(fontSize: 22),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: const CircularProgressIndicator(),
                    ),
                  ]
                : listWidgets(),
          ),
        ),
      ),
    );
  }

  listWidgets() {
    List<Widget> listaWidgets = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.orange,
          height: 250,
          child: Card(
            shadowColor: Colors.red,
            elevation: 120,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Video Inicial'),
                      ),
                      Image.asset(
                        'assets/img/Rocket.jpeg',
                        width: 100,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      uploading
                          ? CircularProgressIndicator(
                              strokeWidth: 0.4,
                            )
                          : IconButton(
                              onPressed: () {
                                pickAndUploadImage(0);
                              },
                              icon: Icon(Icons.add_circle_outline_rounded)),
                      IconButton(
                          onPressed: () {
                            deleteVideo(0);
                          },
                          icon: Icon(Icons.delete_forever)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ];
    for (var x = 1; x < 22; x++) {
      listaWidgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.orange,
            height: 250,
            child: Card(
              shadowColor: Colors.red,
              elevation: 120,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${x}° video'),
                        ),
                        Image.asset(
                          'assets/img/Rocket.jpeg',
                          width: 100,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        uploading
                            ? CircularProgressIndicator(
                                strokeWidth: 0.4,
                              )
                            : IconButton(
                                onPressed: () {
                                  pickAndUploadImage(x);
                                },
                                icon: Icon(Icons.add_circle_outline_rounded)),
                        IconButton(
                            onPressed: () {
                              deleteVideo(x);
                            },
                            icon: Icon(Icons.delete_forever)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return listaWidgets;
  }

  loadVideos() async {
    try {
      refs = (await storage.ref('video').listAll()).items;

      print('foi encontrado ${refs.length} videos no banco de dados');
      for (var ref in refs) {
        arquivos.add(await ref.getDownloadURL());
      }
      arquivos.sort((a, b) => (b.toString()).compareTo((a.toString())));
      setState(() {
        loading = false;
      });
    }  catch (e) {
      setState(() {
        loading = false;
      });
      print('erro ao carregar videos' + e.toString());
    }
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
      showToast(
        'Ero ao fazer uploado:${e.message}',
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
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      );
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
          backgroundColor: Colors.orange,
          position: StyledToastPosition.right,
          animation: StyledToastAnimation.slideFromRight,
          alignment: const Alignment(50, 0),
          textStyle: TextStyle(foreground: Paint()),
          toastHorizontalMargin: 12,
          isHideKeyboard: true,
          reverseCurve: Curves.fastLinearToSlowEaseIn,
          animDuration: const Duration(seconds: 1),
          duration: const Duration(seconds: 3),
          curve: Curves.fastLinearToSlowEaseIn,
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
