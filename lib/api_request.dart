import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<String>> generateImage(String input, int nImage, String size) async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  final apiKey = env["api_key"];
  final url = Uri.parse("https://api.openai.com/v1/images/generations");

  final headers = {
    "Authorization":"Bearer $apiKey",
    "Content-Type": "application/json"
  };

  final body = jsonEncode({
    "prompt": input,
    "n": nImage,
    "size": size,
  });

  final response = await http.post(url, headers: headers, body: body);

  if(response.statusCode == 200) {
    var res = jsonDecode(response.body);
    List<String> imageURL = res['data'];

    return imageURL;
  } else {
    return ["ERROR! Status Code = "];
  }
}