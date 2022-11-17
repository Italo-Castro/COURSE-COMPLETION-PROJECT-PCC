import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/model/Usuario.dart';
import 'package:ta_pago/repository/userRepository.dart';
import 'package:ta_pago/service/auth_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../widgtes/measurements.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class RegisterUser extends StatefulWidget {
  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passworldController = TextEditingController();
  final _repeatPassworldController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneCotroller = TextEditingController();
  bool loading = false;
  bool hidePassworld = true;
  bool hideRepeatPassworld = true;

  final FirebaseStorage storage = FirebaseStorage.instance;
  bool uploading = false;
  double total = 0.0;
  List<Reference> refs = [];
  List<String> arquivos = [];
  XFile? imageProfile;
  File fileImage = new File('');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //rotas nomeadas
      routes: {"/mensurements": (context) => Measurements()},
      home: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.orange,
          backgroundColor: Colors.orange,
          shadowColor: Colors.blue,
          elevation: 10,
          centerTitle: true,
          title: Image.asset('assets/icons/IconApBarLogin.png', width: 230),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Builder(builder: (context) {
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, left: 8, right: 8),
                    child: Stack(
                      children: [
                        Container(
                            width: 190.0,
                            height: 190.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: fileImage.path != ''
                                  ? DecorationImage(
                                      fit: BoxFit.fill,
                                      image: FileImage(fileImage),
                                    )
                                  : const DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          'assets/img/personGymProfile.png'),
                                    ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 32,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Carregar foto'),
                                        content: const Text(
                                            'Escolha de onde carregar a foto'),
                                        actions: <Widget>[
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  getImage('camera');
                                                  Navigator.pop(context, 'OK');
                                                },
                                                child: Row(children: [
                                                  Icon(Icons
                                                      .camera_alt_outlined),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text('Camera'),
                                                  )
                                                ]),
                                              ),
                                            ],
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              getImage('galery');
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: Row(children: [
                                              Icon(Icons.image),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text('Galeria'),
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, left: 8, right: 8),
                    child: TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Por favor informar nome';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Nome'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 8.0, left: 8),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Por favor informar e-mail';
                        }
                        if (value != null && value.contains(' ')) {
                          return 'Seu email pode ter algum espaço em branco, CONFIRA!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text('E-mail'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, right: 8.0, left: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            maxLength: 6,
                            obscureText: hidePassworld,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Por favor informar senha';
                              }
                              if (value!.length < 6) {
                                return 'A senha precisa ter 6 caracteres';
                              }
                              return null;
                            },
                            controller: _passworldController,
                            decoration: InputDecoration(
                              label: Text('Senha'),
                              suffixIcon: IconButton(
                                color: Colors.orange,
                                onPressed: () => setState(() {
                                  hidePassworld = !hidePassworld;
                                }),
                                icon: Icon(Icons.remove_red_eye),
                              ),
                              hintText: 'Senha',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, right: 8.0, left: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            maxLength: 6,
                            obscureText: hideRepeatPassworld,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Por favor informar senha';
                              }
                              if (value!.length < 6) {
                                return 'A senha precisa ter 6 caracteres';
                              }
                              if (_passworldController.text !=
                                  _repeatPassworldController.text) {
                                return 'A senhas não coicidem';
                              }
                              return null;
                            },
                            controller: _repeatPassworldController,
                            decoration: InputDecoration(
                              label: Text('Repetir Senha'),
                              suffixIcon: IconButton(
                                color: Colors.orange,
                                onPressed: () => setState(() {
                                  hideRepeatPassworld = !hideRepeatPassworld;
                                }),
                                icon: Icon(Icons.remove_red_eye),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 8.0, left: 8),
                    child: TextFormField(
                      controller: _phoneCotroller,
                      decoration: InputDecoration(
                        label: const Text('Telefone'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 8.0, left: 8),
                    child: TextFormField(
                      controller: _surnameController,
                      decoration: InputDecoration(
                        label: const Text('Apelido'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    height: 50,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, right: 8.0, left: 8),
                      child: Container(
                        width: 280,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.resolveWith(
                                  (states) => 2),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              shadowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.orangeAccent)),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              registrar();
                            }
                          },
                          child: loading
                              ? const CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  strokeWidth: 2,
                                )
                              : const Text(
                                  'Cadastrar',
                                  style: TextStyle(color: Colors.orange),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, right: 8.0, left: 8),
                      child: Text(''),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  registrar() async {
    try {
      setState(() {
        loading = true;
      });
      await context.read<AuthService>().registrar(
          _emailController.text.trim(), _passworldController.text.trim());
      bool isAdmin = false; //fazer regra
      var uid = context.read<AuthService>().usuario!.uid;
      Usuario user = new Usuario(
          uid,
          _nameController.text,
          _emailController.text.trim(),
          _phoneCotroller.text,
          _surnameController.text,
          _passworldController.text,
          isAdmin,
          true,
          0,
          0,[]);
      await context.read<UserRepository>().insertUser(user);

      //já inserir o usuario vou inserir a foto no storage
      final uidGerado = context.read<UserRepository>().usuarioLogado.uid;
      print('vou grvar a foto de perfil');
      await uploadImage(uidGerado);
      //gravo no firebase e passo pro proximo cadastro de medidas.

      print('vou navehar');
      Navigator.popAndPushNamed(
        context,
        '/mensurements',
      );
      /* Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Measurements();
        },
      ),
    );*/
    } on AuthException catch (e) {
      showToast(
        '${e.message}',
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
      setState(() {
        loading = false;
      });
      /* ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.message}'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );*/
      print('deu erro ao cadastrar register_user linha 144 ' + e.message);
    }
  }

  Future<XFile?> getImage(String cameraOrGalery) async {
    final ImagePicker _picker = ImagePicker();

    XFile? image = await _picker.pickImage(
        source: cameraOrGalery == 'camera'
            ? ImageSource.camera
            : ImageSource.gallery);
    imageProfile = image;
    fileImage = File(image!.path);
    setState(() {});
  }

  uploadImage(String uidUsserLogged) async {
    XFile? file = imageProfile;
    if (file != null) {
      UploadTask task = await upload(file.path, uidUsserLogged);
      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          /*  setState(() {
          uploading = true;
          total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        });*/
        } else if (snapshot.state == TaskState.success) {
          arquivos.add(await snapshot.ref.getDownloadURL());
          refs.add(snapshot.ref);
          /*   setState(() {
          uploading = false;
        });*/
        }
        ;
      });
    } else {
      // se não carregou a imagem vou definir que meu asset seja a minha foto de perfil

      final byteData = await rootBundle.load('assets/img/personGymProfile.png');

      final tempFile =
          File("${(await getTemporaryDirectory()).path}/personGymProfile.png");
      final file = await tempFile.writeAsBytes(
        byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      UploadTask task = await upload(file.path, uidUsserLogged);
      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
        } else if (snapshot.state == TaskState.success) {
          arquivos.add(await snapshot.ref.getDownloadURL());
          refs.add(snapshot.ref);
        }
        ;
      });
    }

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
      print("deu erro para upar foto");
      throw Exception('Erro o upload : ${e.message}');
    }
  }
}
