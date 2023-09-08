import 'package:flutter/material.dart';
import 'package:nixieappflutter/models/gptmodels.dart';
import 'package:nixieappflutter/services/api.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "text-davinci-003";

  String get getCurrentModel {
    return currentModel;
  }

  List<GptModel> modelsList = [];

  List<GptModel> get getModelsList {
    return modelsList;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  Future<List<GptModel>> getAllModels() async {
    modelsList = await Api.getModels();
    return modelsList;
  }
}
