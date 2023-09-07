import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nixieappflutter/constants/api_constants.dart';
import 'package:nixieappflutter/models/gptmodels.dart';

class Api {
  static Future<List<GptModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $OPENAI_API_KEY'},
      );
      Map jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        print('temp $value');
      }
      return GptModel.modelsFromSnapshot(temp);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
