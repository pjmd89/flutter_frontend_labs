import 'package:flutter/material.dart';
class DrawerButtonConfig {
  Icon leadingIcon;
  String currentPath;
  String buttonText;
  String buttonRoute;
  void Function(BuildContext)? callback;
  DrawerButtonConfig({required this.buttonText, required this.buttonRoute, this.callback, required this.currentPath, required this.leadingIcon});
  bool get isSelected {
    bool isSelected = false;
    if (buttonRoute == currentPath) {
      isSelected = true;
    }
    return isSelected;
  }
}
