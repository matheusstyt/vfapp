import 'package:flutter/material.dart';

class Singleton {
  static final Singleton _instance = Singleton._internal();
  factory Singleton() => _instance;

  Singleton._internal() {
    tController = ThemeController();
  }

  static ThemeController tController = ThemeController();

  //short getter for my variable
  ThemeController get myVariable => tController;

  void atualizaTema(bool tema) {
    tController.atualizaBrightness(tema);
  }

  Brightness temaAtual(bool tema) {
    return tController.brightness;
  }

  //short setter for my variable
  set myVariable(ThemeController themeController) =>
      tController = themeController;
}

class ThemeController extends ChangeNotifier {
  Brightness brightness = Brightness.dark;

  void atualizaBrightness(bool tema) {
    this.brightness = tema ? Brightness.dark : Brightness.light;
    notifyListeners();
  }
}
