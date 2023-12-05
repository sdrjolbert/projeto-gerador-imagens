import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gerador_imagens/login_page.dart';
import 'package:gerador_imagens/main_page.dart';
import 'package:gerador_imagens/signup_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador de Imagens',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.green,
        fontFamily: "Roboto"
      ),
      home: const AuthLoginPage()
    );
  }
}
