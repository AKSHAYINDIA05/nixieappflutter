import 'package:flutter/material.dart';
import 'package:nixieappflutter/models/chatmodel.dart';

import '../services/api.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    chatList.addAll(
      await Api.sendMessage(message: msg, modelId: chosenModelId),
    );
  }
}
