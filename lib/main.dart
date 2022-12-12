import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/repository/configurationRepository.dart';
import 'package:ta_pago/repository/userRepository.dart';
import 'package:ta_pago/service/auth_service.dart';
import 'package:ta_pago/service/connection.dart';
import 'package:ta_pago/widgtes/auth_check.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await FlutterDownloader.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserRepository(
            auth: AuthService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Connection(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConfigurationRepository(
            auth: AuthService(),
          ),
        ),
      ],
      child: const AuthCheck(),
    ),
  );
}
