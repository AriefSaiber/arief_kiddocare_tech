import 'package:arief_kiddocare_tech/model/listing_mdl.dart';
import 'package:arief_kiddocare_tech/services/listing_svc.dart';
import 'package:flutter/material.dart';

class KindergartenProvider with ChangeNotifier {
  final KindergartenService _service = KindergartenService();
  List<Kindergarten> _kindergartens = [];
  bool _isLoading = false;
  int _page = 1;
  final int _perPage = 10;
  int _totalPages = 1;

  List<Kindergarten> get kindergartens => _kindergartens;
  bool get isLoading => _isLoading;
  int get totalPages => _totalPages;

  Future<void> fetchKindergartens() async {
    if (_isLoading || _page > _totalPages) return;

    _isLoading = true;
    Future.microtask(() => notifyListeners()); // Delay notifyListeners

    try {
      final pagination = await _service.fetchKindergartens(page: _page, perPage: _perPage);
      _kindergartens.addAll(pagination.data);
      _totalPages = pagination.pages;
      _page++;
    } catch (e) {
      print('Error fetching kindergartens: $e');
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners()); // Delay notifyListeners
    }
  }

  Future<Kindergarten> fetchKindergartenDetails(String id) async {
    try {
      return await _service.fetchKindergartenDetails(id);
    } catch (e) {
      print('Error fetching kindergarten details: $e');
      throw e;
    }
  }
}
