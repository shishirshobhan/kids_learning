import 'dart:convert';
import 'package:http/http.dart' as http;

class Helper {
  static Future<List> getAllSound() async {
    List sounds = [];
    var url = Uri.parse('http://10.0.2.2:8000/api/all-learning');
    var response = await http.get(url);
    Map dataAsItIs = jsonDecode(response.body);
    sounds = dataAsItIs['learning'];
    return sounds;
  }
}