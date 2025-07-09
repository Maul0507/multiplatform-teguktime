import 'package:flutter/material.dart';
import '../models/artikel_model.dart';
import '../services/artikel_service.dart';

class ArtikelProvider with ChangeNotifier {
  final ArtikelService _artikelService = ArtikelService();

  List<ArtikelModel> _artikelList = [];
  ArtikelModel? _selectedArtikel;
  bool _isLoading = false;

  List<ArtikelModel> get artikelList => _artikelList;
  ArtikelModel? get selectedArtikel => _selectedArtikel;
  bool get isLoading => _isLoading;

  // Ambil semua artikel
  Future<void> fetchArtikelList() async {
    _isLoading = true;
    notifyListeners();

    try {
      _artikelList = await _artikelService.fetchArtikelList();
    } catch (e) {
      print('Error fetchArtikelList: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Ambil satu artikel
  Future<void> getArtikelById(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedArtikel = await _artikelService.getArtikelById(id);
    } catch (e) {
      print('Error getArtikelById: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Tambahkan artikel
  Future<void> addArtikel(ArtikelModel artikel) async {
    try {
      final newArtikel = await _artikelService.createArtikel(artikel);
      _artikelList.add(newArtikel);
      notifyListeners();
    } catch (e) {
      print('Error addArtikel: $e');
    }
  }

  // Update artikel
  Future<void> updateArtikel(ArtikelModel artikel) async {
    try {
      final updated = await _artikelService.updateArtikel(artikel);
      final index = _artikelList.indexWhere((a) => a.id == artikel.id);
      if (index != -1) {
        _artikelList[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      print('Error updateArtikel: $e');
    }
  }

  // Hapus artikel
  Future<void> deleteArtikel(int id) async {
    try {
      await _artikelService.deleteArtikel(id);
      _artikelList.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleteArtikel: $e');
    }
  }

  void clearSelected() {
    _selectedArtikel = null;
    notifyListeners();
  }
}
