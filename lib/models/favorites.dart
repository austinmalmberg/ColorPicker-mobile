import 'package:flutter/material.dart';

class Favorites extends ChangeNotifier {
  final List<int> _items = [];

  List<int> get items => _items;

  void add(int itemNo) {
    items.add(itemNo);
    notifyListeners();
  }

  void remove(int itemNo) {
    items.remove(itemNo);
    notifyListeners();
  }
}
