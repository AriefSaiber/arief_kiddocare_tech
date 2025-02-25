import 'package:arief_kiddocare_tech/component/snackbar.dart';
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
  bool isSearch = false;

  List<Kindergarten> get kindergartens => _filteredKindergartens;
  // bool get isSearch => _isSearch;
  bool get isLoading => _isLoading;
  int get totalPages => _totalPages;
  String get searchQuery => _searchQuery;
  int get currentPage => _page; // Add this getter

  List<String> stateList = [
    "All States",
    "Selangor",
    "Perlis",
    "Kedah",
    "Perak",
    "Johor",
    "Pahang",
    "Sabah",
    "Sarawak",
    "Federal Territory of Putrajaya",
    "Federal Territory of Kuala Lumpur",
    "Malacca",
    "Penang"
  ];

  //=========================FETCH BY PAGES=========================
  Future<void> fetchKindergartens(BuildContext context, {int page = 1, String query = ""}) async {
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
      snackBar(context, 'Error fetching kindergartens: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //=========================FETCH FILTERED KINDERGARTENS=========================
  Future<void> fetchFilteredKindergartens(BuildContext context, {String? name, String? state}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.fetchAllKindergartens();
      _kindergartens = response;

      if (state == "All States") {
        state = "";
      }

      _filteredKindergartens = _kindergartens.where((kindergarten) {
        final matchesName =
            name == null || name.isEmpty || kindergarten.name.toLowerCase().contains(name.toLowerCase());
        final matchesState = state == null || state.isEmpty || kindergarten.state.toLowerCase() == state.toLowerCase();
        return matchesName && matchesState;
      }).toList();
    } catch (e) {
      snackBar(context, 'Error fetching kindergartens: $e');
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

  Future<Kindergarten> fetchKindergartenDetails(BuildContext context, String id) async {
    try {
      return await _service.fetchKindergartenDetails(id);
    } catch (e) {
      snackBar(context, 'Error fetching kindergarten details: $e');
      throw e;
    }
  }
}
