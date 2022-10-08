import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../model/Usuario.dart';
import '../../../repository/userRepository.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../menuItensAdmin.dart';
import '../menuItensNotAdmin.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
      // loadImages(usserLogged.uid);

      _nickName.text =
          usserLogged.apelido != null ? usserLogged.apelido.toString() : '';
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações do perfil de ${usserLogged.nome}',
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      drawer: SafeArea(
        child: CollapsibleSidebar(
          items: usserLogged.isAdmin
              ? menuItens(context, 'profileConfiguration')
              : menuItensNotAdmin(context, 'profileConfiguration'),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5, right: 8.0, left: 8),
              child: Card(
                child: Text(
                    'Até agora você conquistou ${usserLogged.pontuacao != null ? usserLogged.pontuacao : 0} pontos'),
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
              child: RatingBar.builder(
                initialRating: usserLogged.avaliacaoApp,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  usserLogged.avaliacaoApp = rating;
                },
              ), /*TextFormField(
                controller: _appEvaluation,
                decoration: InputDecoration(
                  labelText: 'Nota do aplicativo 0 - 5',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),*/
            ),
            Text('Sua avaliação para o app'),
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
    try {
      usserLooged.apelido = _nickName.text;
      usserLooged.avaliacaoApp = double.tryParse(_appEvaluation.text)!;
      Provider.of<UserRepository>(context, listen: false).update(usserLooged);
      showToast(
        'Informações Atualizadas!',
        alignment: const Alignment(50, 0),
        context: context,
        textStyle: TextStyle(foreground: Paint()),
        backgroundColor: Colors.blueAccent,
        position: StyledToastPosition.bottom,
        duration: const Duration(seconds: 5),
        curve: Curves.elasticInOut,
        animDuration: const Duration(seconds: 2),
        animation: StyledToastAnimation.fadeScale,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      );
    } catch (e) {
      showToast(
        'Erro ao salvar infomrações do perfil!',
        alignment: const Alignment(50, 0),
        context: context,
        textStyle: TextStyle(foreground: Paint()),
        backgroundColor: Colors.red,
        position: StyledToastPosition.bottom,
        duration: const Duration(seconds: 5),
        curve: Curves.elasticInOut,
        animDuration: const Duration(seconds: 2),
        animation: StyledToastAnimation.fadeScale,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      );
      print('erro ao fazer update cadastro usuario'+e.toString());
    }
  }

  loadImages(String uidUsserLogged) async {
    try {
      refs = (await storage.ref('${uidUsserLogged}/').listAll()).items;
      for (var ref in refs) {
        arquivos.add(await ref.getDownloadURL());
      }
    } catch (e) {
      showToast(
        'Erro ao carregar imagens',
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
    }
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
    } on FirebaseException catch (e) {
      showToast(
        'Erro ao enviar foto',
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

      print("deu erro para upar foto");
      throw Exception('Erro o upload : ${e.toString()}');
    }
  }

  pickAndUploadImage(String uidUsserLogged) async {
    try {
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
    } catch (e) {
      showToast(
        'Erro ao enviar foto',
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
    }
  }
}
