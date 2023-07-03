import 'package:flutter/material.dart';
import 'package:gerador_imagens/firebase_interface.dart';
import 'package:gerador_imagens/signup_page.dart';
import 'package:gerador_imagens/main_page.dart';
import 'package:gerador_imagens/main.dart';
import 'package:gerador_imagens/utils.dart';

class AuthLoginPage extends StatefulWidget {
  const AuthLoginPage({super.key});

  @override
  State<AuthLoginPage> createState() => AuthLoginState();
}

class AuthLoginState extends State<AuthLoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future login() async {
    final email = _emailController.text.trim();
    final passwd = _passwordController.text.trim();

    if(email.isEmpty || passwd.isEmpty) {
      Utils.toast("Há campos não preenchidos! Por favor, preencha todos os campos!");
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text("Há campos não preenchidos! Por favor, preencha todos os campos!"),
      //     )
      // );
    }

    final FirebaseInterface fbInt = FirebaseInterface();
    final err = await fbInt.signIn(email, passwd);

    if(err == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
        Utils.toast("Erro ao fazer o login! Código de erro: $err");
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //         content: Text('Erro ao fazer o login! Código de erro: $err')
      //     )
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    const int mainBackgroundColor = 0xFFFAFAFC;
    const int secBackgroundColor = 0xFFF2F2F6;
    const int mainFontColor = 0xFF6e6e80;
    const int secFontColor = 0xFF1A7F64;
    const int mainHighlighter = 0xFF777777;
    const int secHighlighter = 0xFFD2F4D3;
    const int mainFontHighlighter = 0xFF10a37f;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 35),
              alignment: Alignment.center,
              child: const Text(
                "Gerador de Imagens",
                style: TextStyle(
                  color: Color(secFontColor),
                  fontFamily: "Roboto",
                  fontSize: 30,
                ),
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Icon(Icons.person, size: 30),
                SizedBox(
                  height: 50,
                  width: 275,
                  child: TextField(
                    controller: _emailController,
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                                width: 1.5,
                                color: Colors.green
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                                width: 1.5,
                                color: Color(secBackgroundColor)
                            )
                        ),
                        labelText: "E-mail",
                        labelStyle: TextStyle(
                          color: Color(mainFontColor)
                        ),
                        floatingLabelStyle: TextStyle(
                          color: Color(secFontColor)
                        ),
                        hintText: "email@exemplo.com",
                        hintStyle: TextStyle(
                          color: Color(mainFontColor),
                        ),
                        filled: true,
                        fillColor: Colors.transparent
                    ),
                    style: const TextStyle(
                        color: Color(mainHighlighter),
                        fontSize: 19
                    ),
                  )
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Icon(Icons.password, size: 30,),
                SizedBox(
                  height: 50,
                  width: 275,
                  child: TextField(
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: _passwordController,
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Colors.green
                        )
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Color(secBackgroundColor)
                        )
                      ),
                      labelText: "Senha",
                      labelStyle: TextStyle(
                        color: Color(mainFontColor)
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Color(secFontColor)
                      ),
                      hintText: "********",
                      hintStyle: TextStyle(
                        color: Color(mainFontColor),
                      ),
                      filled: true,
                      fillColor: Colors.transparent
                      ),
                      style: const TextStyle(
                        color: Color(mainHighlighter),
                        fontSize: 19
                      ),
                    )
                  )
                ],
              )
            ),
            Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: login,
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
              )
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: TextButton(
                style: const ButtonStyle(alignment: Alignment.center),
                child: const Text("Não tem uma conta? Cadastre-se"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AuthSignUpPage();
                  }));
                },
              )
            ),
            // Container(
            //   padding: const EdgeInsets.only(top: 25),
            //   child: Row(
            //     children: <Widget>[
            //       Expanded(
            //         child: Container(
            //           padding: const EdgeInsets.only(left: 20, right: 15),
            //           child: const Divider(
            //             thickness: .7,
            //             color: Color(mainHighlighter)
            //           )
            //         )
            //       ),
            //       const Text("OU", style: TextStyle(color: Color(mainFontColor))),
            //       Expanded(
            //         child: Container(
            //           padding: const EdgeInsets.only(left: 15, right: 20),
            //           child: const Divider(
            //             thickness: .7,
            //             color: Color(mainHighlighter)
            //           )
            //         )
            //       )
            //     ],
            //   )
            // ),
            // Container(
            //   padding: const EdgeInsets.only(top: 45),
            //   child: SizedBox(
            //     height: 45,
            //     width: 230,
            //     child: OutlinedButton.icon(
            //       icon: Image.asset(
            //         "assets/images/google_logo.png",
            //         height: 24,
            //         width: 24,
            //       ),
            //       style: ButtonStyle(
            //         alignment: Alignment.center,
            //         shape: MaterialStateProperty.all(
            //           RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(30)
            //           )
            //         )
            //       ),
            //       onPressed: googleLogin,
            //       label: const Text(
            //         "Continue com Google",
            //         style: TextStyle(
            //           fontSize: 16
            //         ),
            //       ),
            //     ),
            //   )
            // )
          ],
        ),
      ),
      backgroundColor: const Color(mainBackgroundColor)
    );
  }
}