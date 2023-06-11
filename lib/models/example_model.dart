// To parse this JSON data, do
//
//     final exampleModel = exampleModelFromJson(jsonString);

import 'dart:convert';

ExampleModel exampleModelFromJson(String str) =>
    ExampleModel.fromJson(json.decode(str));

String exampleModelToJson(ExampleModel data) => json.encode(data.toJson());

class ExampleModel {
  ExampleModel({
    required this.greeting,
    required this.instructions,
  });

  String greeting;
  List<String> instructions;

  factory ExampleModel.fromJson(Map<String, dynamic> json) => ExampleModel(
        greeting: json["greeting"],
        instructions: List<String>.from(json["instructions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "greeting": greeting,
        "instructions": List<dynamic>.from(instructions.map((x) => x)),
      };
}
