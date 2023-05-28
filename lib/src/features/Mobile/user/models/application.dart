import 'dart:io';

class Application {
  late File cv;

  Application({
    required this.cv,
  });

  static Application fromJson(json) => Application(cv: json['cv']);


  Map<String, dynamic> toJson() => {
        'cv': cv,
      };
}


