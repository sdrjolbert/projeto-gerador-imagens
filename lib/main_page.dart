import 'dart:typed_data';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:gerador_imagens/login_page.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import 'package:gerador_imagens/utils.dart';
import 'package:gerador_imagens/api_request.dart';
import 'package:gerador_imagens/firebase_interface.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late TextEditingController _inputController;
  late TextEditingController _numberController;
  late TextEditingController _sizeController;

  List<int> listNImages = [1, 2, 3, 4];
  List<String> listSizes = ["256x256", "512x512", "1024x1024"];

  bool isLoading = false;

  int _keyCounter = 0;

  List<Widget> responseWidget = [];
  int len = 0;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _numberController = TextEditingController();
    _sizeController = TextEditingController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _numberController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  void _saveNetworkImage(String url) async {
    setState(() {
      isLoading = true;
    });

    var response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60
    );

    if( (result["isSuccess"] == true      || result["isSuccess"] == "true") &&
        (result["errorMessage"] != null   || result["errorMessage"] != "null")) {
      Utils.toast("Imagem baixada com sucesso!");
    } else {
      Utils.toast("Não foi possível baixar a imagem. Código de erro: ${result["errorMessage"]}");
    }

    setState(() {
      isLoading = false;
    });
  }

  void resetFuture() {
    setState(() {
      _keyCounter++;
    });
  }

  void createWidget(String input, int n, String size) {
    responseWidget.add(
        FutureBuilder(
          key: ValueKey<int>(_keyCounter),
          future: generateImage(input, n, size),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              List<String> res = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  for(var image in res) Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            child: Image.network(
                              image.toString(),
                              width: 275,
                              height: 275,
                              fit: BoxFit.fitWidth,
                            )
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: SizedBox(
                              height: 50,
                              width: 275,
                              child: isLoading ?
                                const Center(child: CircularProgressIndicator())
                                  :
                                OutlinedButton.icon(
                                icon: const Icon(Icons.save_alt, size: 28),
                                onPressed: () {
                                  _saveNetworkImage(image);
                                },
                                label: const Text(
                                  "Baixar",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            )
                          )
                        ],
                      )
                    ),
                  )
                ],
              );
          } else {
            return Container(
                margin: const EdgeInsets.only(top: 100),
                child: const CircularProgressIndicator()
            );
          }
        },
      )
    );
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
      appBar: AppBar(
        title: const Text("Gerador de Imagens"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') {
                FirebaseInterface().signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthLoginPage()));
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.logout, size: 24, color: Color(mainHighlighter)),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text("Logout", style: TextStyle(color: Color(mainFontColor), fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 25, bottom: 20),
                    child: SizedBox(
                        height: 110,
                        width: 350,
                        child: TextField(
                          controller: _inputController,
                          textAlign: TextAlign.left,
                          maxLines: 3,
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
                            labelText: "Texto base para gerar a imagem",
                            labelStyle: TextStyle(
                                color: Color(mainFontColor)
                            ),
                            floatingLabelStyle: TextStyle(
                                color: Color(secFontColor)
                            ),
                            hintText: "Um céu azul com nuvens",
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          const Text(
                            "Número de Imagens",
                            style: TextStyle(
                              color: Color(mainFontColor),
                              fontSize: 16
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: DropdownButtonFormField<int>(
                                value: _numberController.text.isNotEmpty
                                    ? int.parse(_numberController.text)
                                    : null,
                                dropdownColor: const Color(secBackgroundColor),
                                hint: const Text("1"),
                                style: const TextStyle(
                                  fontSize: 19,
                                  color: Color(mainFontColor),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _numberController.text = newValue!.toString();
                                  });
                                },
                                items: listNImages.map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ),
                            )
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          const Text(
                            "Resolução das Imagens",
                            style: TextStyle(
                              color: Color(mainFontColor),
                              fontSize: 16
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: SizedBox(
                              width: 130,
                              height: 50,
                              child: DropdownButtonFormField<String>(
                                value: _sizeController.text.isNotEmpty
                                    ? _sizeController.text
                                    : null,
                                dropdownColor: const Color(secBackgroundColor),
                                hint: const Text("256x256"),
                                style: const TextStyle(
                                  fontSize: 19,
                                  color: Color(mainFontColor),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _sizeController.text = newValue!;
                                  });
                                },
                                items: listSizes.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            )
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          responseWidget.clear();
                        });
                        resetFuture();
                        setState(() {
                          createWidget(
                            _inputController.text,
                            int.parse(_numberController.text),
                            _sizeController.text,
                          );
                        });
                      },
                      child: const Text(
                        "Gerar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                    )
                  ),
                  Column(
                    children: <Widget>[
                      Column(
                        children: responseWidget,
                      )
                    ],
                  )
                ]
              )
            )
          ],
        ),
      ),
      backgroundColor: const Color(mainBackgroundColor)
    );
  }
}