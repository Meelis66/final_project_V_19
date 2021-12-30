import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


class SPSettings {
  static SPSettings? _instance;
  final String fontSizeKey = 'font_size';
  final String colorKey = 'color';
  static late SharedPreferences _sp;

  factory SPSettings() {
    if (_instance == null) {
      _instance = SPSettings._internal();
    }
    return _instance as SPSettings;
  }

  SPSettings._internal();

  Future init() async {
    _sp = await SharedPreferences.getInstance();
    
  }

  double? getFontSize() {
    double? fontSize = _sp.getDouble(fontSizeKey);
    if (fontSize == 0) {
      fontSize = 14;
    }
    return fontSize;
  }

  Future setFontSize(double size) {
    return _sp.setDouble(fontSizeKey, size);
  }

  int getColor() {
    int? color = _sp.getInt(colorKey);
    if (color == null) {
      return 0xff1976D2; //blue
    } else {
      return color;
    }
  }

  Future setColor(int color) {
    return _sp.setInt(colorKey, color);
  }

 

  
}
