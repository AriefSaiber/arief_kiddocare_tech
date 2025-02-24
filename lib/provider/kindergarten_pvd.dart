import 'package:arief_kiddocare_tech/model/kindergarten_mdl.dart';
import 'package:arief_kiddocare_tech/services/kindergarten_svc.dart';
import 'package:flutter/material.dart';

class KindergartenProvider with ChangeNotifier {
  final KindergartenService _service = KindergartenService();
  List<Kindergarten> _kindergartens = [];
  List<Kindergarten> _filteredKindergartens = [];
  bool _isLoading = false;
  int _page = 1;
  final int _perPage = 10;
  int _totalPages = 1;
  String _searchQuery = '';
  String _selectedState = '';
  String _selectedCity = '';

  List<Kindergarten> get kindergartens => _filteredKindergartens;
  bool get isLoading => _isLoading;
  int get totalPages => _totalPages;
  String get searchQuery => _searchQuery;
  int get currentPage => _page; // Add this getter

  Future<void> fetchKindergartens({int page = 1, String query = ""}) async {
    if (_isLoading || page > _totalPages) return;

    _isLoading = true;
    notifyListeners();

    try {
      final pagination = await _service.fetchKindergartens(page: page, perPage: _perPage);
      _kindergartens = pagination.data; // Reset instead of adding
      _filteredKindergartens = _kindergartens;
      _totalPages = pagination.pages;
      _page = page;
      _searchQuery = query;
      _filteredKindergartens = _applyFilter();
    } catch (e) {
      print('Error fetching kindergartens: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFilteredKindergartens({String? name, String? state}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.fetchKindergartens(page: 1, perPage: _perPage);
      _kindergartens = response.data;

      _filteredKindergartens = _kindergartens.where((kindergarten) {
        final matchesName =
            name == null || name.isEmpty || kindergarten.name.toLowerCase().contains(name.toLowerCase());
        final matchesState = state == null || state.isEmpty || kindergarten.state.toLowerCase() == state.toLowerCase();
        return matchesName && matchesState;
      }).toList();
    } catch (e) {
      print('Error fetching kindergartens: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Kindergarten> _applyFilter() {
    if (_searchQuery.isEmpty) {
      return _kindergartens;
    }
    return _kindergartens.where((k) {
      return k.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          k.city.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filteredKindergartens = _applyFilter();
    notifyListeners();
  }

  List<String> getStates() {
    final states = _kindergartens.map((k) => k.state).toSet().toList();
    states.sort();
    states.insert(0, 'All Locations');
    return states;
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
