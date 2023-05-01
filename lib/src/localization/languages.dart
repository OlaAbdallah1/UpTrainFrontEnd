import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;

  String get loginAs;
  String get student;
  String get company;

  String get labelWelcome;

  String get labelInfo;

  String get labelSelectLanguage;
}
