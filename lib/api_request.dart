import 'package:dotenv/dotenv.dart';
import 'package:gerador_imagens/api_key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<String>> generateImage(String input, int nImage, String size) async {
  final url = Uri.parse("https://api.openai.com/v1/images/generations");

  final headers = {
    "Authorization": "Bearer ${ApiKey().key}",
    "Content-Type": "application/json"
  };

  final body = jsonEncode({
    "prompt": input,
    "n": nImage,
    "size": size,
  });

  final response = await http.post(url, headers: headers, body: body);

  if(response.statusCode == 200) {
    var res = jsonDecode(response.body.toString());
    List imageURL = res["data"];
    List<String> images = [];

    for(var e in imageURL) {
      var el = e["url"];
      images.add(el);
    }

    return images;
  } else {
    return ["ERROR! Status Code: ${response.statusCode}"];
  }
}