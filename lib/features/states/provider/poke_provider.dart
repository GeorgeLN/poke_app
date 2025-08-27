
import 'package:flutter/material.dart';

class PokeProvider extends ChangeNotifier {
  String? _cantidad;

  String? get getCantidad => _cantidad;

  void setCantidad(String value) {
    _cantidad = value;
    notifyListeners();
  }
}