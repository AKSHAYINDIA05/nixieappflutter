class GptModel {
  final String id;
  final int created;
  final String root;
  GptModel({
    required this.id,
    required this.created,
    required this.root,
  });

  factory GptModel.fromJson(Map<String, dynamic> json) => GptModel(
        id: json["id"],
        created: json["created"],
        root: json["root"],
      );

  static List<GptModel> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((data) => GptModel.fromJson(data)).toList();
  }
}
