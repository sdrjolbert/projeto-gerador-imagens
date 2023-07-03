import 'package:flutter/material.dart';
import 'package:gerador_imagens/color_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerador_imagens/login_page.dart';
import 'package:gerador_imagens/main_page.dart';
import 'package:gerador_imagens/signup_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> checkUserLoggedIn() async {
    return _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador de Imagens',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xFF10a37f)),
        fontFamily: "Roboto"
      ),
      home: FutureBuilder<User?>(
        future: checkUserLoggedIn(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return const HomePage();
          } else {
            return const AuthLoginPage();
          }
        },
      )
    );
  }
}
