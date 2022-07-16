import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  Future<String> getCat() async {
    const url = "https://api.thecatapi.com/v1/images/search";
    Uri uri = Uri.parse(url);
    var Response = await http.get(uri);
    return jsonDecode(Response.body)[0]["url"];
  }
}
