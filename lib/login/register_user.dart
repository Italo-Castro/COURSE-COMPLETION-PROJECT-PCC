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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/icons/IconApBarLogin.png', width: 230),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Builder(builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    getImage();
                  },
                  child: Container(
                    width: 190.0,
                    height: 190.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/img/personGymProfile.png'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 8, right: 8),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _nameController,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Por favor informar nome';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text('Nome'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, right: 8.0, left: 8),
                  child: TextFormField(
                    textAlign: TextAlign.center,
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
                          textAlign: TextAlign.center,
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
                          textAlign: TextAlign.center,
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
                  padding: EdgeInsets.only(top: 20, right: 8.0, left: 8),
                  child: TextFormField(
                    controller: _phoneCotroller,
                    decoration: InputDecoration(
                      label: Text('Telefone'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, right: 8.0, left: 8),
                  child: TextFormField(
                    controller: _surnameController,
                    decoration: InputDecoration(
                      label: Text('Apelido'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 280,
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 8.0, left: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          registrar();
                        }
                      },
                      child: loading
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text('Cadastrar'),
                    ),
                  ),
                )
              ],
            );
          }),
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
          true);
      await context.read<UserRepository>().insertUser(user);

      //já inserir o usuario vou inserir a foto no storage
      final uidGerado = await context.read<UserRepository>().usuarioLogado.uid;

      uploadImage(uidGerado);
      //gravo no firebase e passo pro proximo cadastro de medidas.
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Measurements();
          },
        ),
      );
    } on AuthException catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.message}'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
      print('deu erro ao cadastrar register_user linha 144 ' + e.message);
    }
  }

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();

    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    imageProfile = image;
  }

  uploadImage(String uidUsserLogged) async {
    XFile? file = imageProfile;
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
