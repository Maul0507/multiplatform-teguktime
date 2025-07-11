import 'package:flutter/material.dart';

class RiwayatItem {
  final String tanggal;
  final String kebutuhan;
  final String jadwal;
  final String progress;

  RiwayatItem({
    required this.tanggal,
    required this.kebutuhan,
    required this.jadwal,
    required this.progress,
  });
}

class RiwayatProvider extends ChangeNotifier {
  final List<RiwayatItem> _items = [];

  List<RiwayatItem> get items => _items;

  void addRiwayat(RiwayatItem item) {
    _items.insert(0, item); // tambah di awal
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}
