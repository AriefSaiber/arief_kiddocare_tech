import 'package:arief_kiddocare_tech/model/listing_mdl.dart';
import 'package:arief_kiddocare_tech/services/listing_svc.dart';
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

  List<Kindergarten> get kindergartens => _filteredKindergartens;
  bool get isLoading => _isLoading;
  int get totalPages => _totalPages;
  int get currentPage => _page; // Add this getter

  Future<void> fetchKindergartens({int page = 1}) async {
    if (_isLoading || page > _totalPages) return;

    _isLoading = true;
    notifyListeners();

    try {
      final pagination = await _service.fetchKindergartens(page: page, perPage: _perPage);
      _kindergartens = pagination.data; // Reset instead of adding
      _filteredKindergartens = _kindergartens;
      _totalPages = pagination.pages;
      _page = page; // Update current page
    } catch (e) {
      print('Error fetching kindergartens: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchfilteredKindergartens({required String name, required String state}) async {
    if (_isLoading || _page > _totalPages) return;

    _isLoading = true;
    notifyListeners();

    try {
      final pagination = await _service.fetchKindergartens(page: _page, perPage: _perPage);
      _kindergartens.addAll(pagination.data);
      _filteredKindergartens = _kindergartens;
      _totalPages = pagination.pages;
      _page++;
    } catch (e) {
      print('Error fetching kindergartens: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterKindergartens({String? query, String? state}) {
    _searchQuery = query?.toLowerCase() ?? '';
    _selectedState = state ?? '';

    if (_searchQuery.isEmpty && _selectedState.isEmpty) {
      _filteredKindergartens = _kindergartens; // Show all items if no filters
    } else {
      _filteredKindergartens = _kindergartens.where((kindergarten) {
        final matchesName = _searchQuery.isEmpty || kindergarten.name.toLowerCase().contains(_searchQuery);
        final matchesState = _selectedState.isEmpty || kindergarten.state.toLowerCase() == _selectedState.toLowerCase();
        return matchesName && matchesState;
      }).toList();
    }
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
