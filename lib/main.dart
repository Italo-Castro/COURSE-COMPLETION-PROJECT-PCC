

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/repository/userRepository.dart';
import 'package:ta_pago/service/auth_service.dart';
import 'package:ta_pago/service/connection.dart';
import 'firebase_options.dart';
import 'login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        )
      ],
      child: Login(),
    ),
  );
}

