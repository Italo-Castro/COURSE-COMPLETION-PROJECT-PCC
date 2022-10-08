import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/repository/userRepository.dart';
import '../model/Usuario.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'homePage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
class RegisterMeasurements extends StatefulWidget {
  const RegisterMeasurements({Key? key}) : super(key: key);

  @override
  State<RegisterMeasurements> createState() => _RegisterMeasurementsState();
}

class _RegisterMeasurementsState extends State<RegisterMeasurements> {
  final _bustoController = TextEditingController();
  final _toraxController = TextEditingController();
  final _bracoController = TextEditingController();
  final _cinturaController = TextEditingController();
  final _abdomenController = TextEditingController();
  final _quadrilController = TextEditingController();
  final _coxaController = TextEditingController();
  final _panturrilhaController = TextEditingController();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          'Informe suas medidas',
          textAlign: TextAlign.center,
        )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _bustoController,
                  decoration: InputDecoration(
                    label: Text('Busto (cm)'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _toraxController,
                  decoration: InputDecoration(
                    label: Text('Tórax (cm)'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _bracoController,
                  decoration: InputDecoration(
                    label: Text('Braços (cm)'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _cinturaController,
                  decoration: InputDecoration(
                    label: Text('Cintura (cm)'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _abdomenController,
                  decoration: InputDecoration(
                    label: Text('Abdômen (cm)'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _quadrilController,
                  decoration: InputDecoration(
                    label: Text('Quadril (cm)'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _coxaController,
                  decoration: InputDecoration(
                    label: Text('Coxas (cm)'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _panturrilhaController,
                  decoration: InputDecoration(
                    label: Text('Panturrilhas (cm)'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => salvar(),
                child: Text('Salvar'),
              ),
              Text('Clique no botão para salvar.')
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('oi');
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => Container(child: Image.asset('assets/img/Medidas.jpeg')),
            );
          },
          child: Icon(Icons.question_mark),
        ),
      ),
    );
  }

  salvar() async {
    Usuario user = await Provider.of<UserRepository>(context, listen: false)
        .usuarioLogado; //context.read()<UserRepository>().usuarioLogado;
    user.busto = _bustoController.text;
    user.torax = _toraxController.text;
    user.bracos = _bracoController.text;
    user.cintura = _cinturaController.text;
    user.abdomen = _abdomenController.text;
    user.quadril = _quadrilController.text;
    user.coxas = _coxaController.text;
    user.panturilha = _panturrilhaController.text;
    user.panturilha = _panturrilhaController.text;

    await context.read<UserRepository>().update(user);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      ),
    );
  }
}
