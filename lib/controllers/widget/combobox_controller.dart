import 'package:flutter/material.dart';

class ComboboxController<T> extends ChangeNotifier {
  List<T> list;
  int index = 0;
  T? value;
  ComboboxController({required this.list}) {
    value = list.firstOrNull;
  }
  setItem(int index, T? value) {
    this.index = index;
    this.value = value;
    notifyListeners();
  }
}
