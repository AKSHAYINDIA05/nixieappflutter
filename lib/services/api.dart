import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nixieappflutter/constants/api_constants.dart';
import 'package:nixieappflutter/models/chatmodel.dart';
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
        // print('temp ${value["id"]}');
      }
      return GptModel.modelsFromSnapshot(temp);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      var response = await http.post(Uri.parse("$BASE_URL/completions"),
          headers: {
            'Authorization': 'Bearer $OPENAI_API_KEY',
            'Content-type': 'application/json',
          },
          body: jsonEncode(
            {
              "model": modelId,
              "prompt": message,
              "max_tokens": 100,
            },
          ));
      Map jsonResponse = jsonDecode(response.body);
      // print(jsonResponse);
      // if (jsonResponse['error'] == null) {
      //   throw HttpException(jsonResponse['error']['message']);
      // }

      List<ChatModel> chatList = [];
      if (jsonResponse['choices'].length > 0) {
        // print(
        //     "jsonResponse[choices]text ${jsonResponse['choices'][0]['text']}");
        chatList = List.generate(
          jsonResponse['choices'].length,
          (index) => ChatModel(
            msg: jsonResponse['choices'][index]['text'],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
