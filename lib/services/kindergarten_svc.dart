import 'dart:convert';
import 'dart:developer';
import 'package:arief_kiddocare_tech/model/kindergarten_mdl.dart';
import 'package:http/http.dart' as http;

class KindergartenService {
  final String baseUrl = 'https://flutter-test.kiddocare.my/kindergartens';

  Future<Pagination> fetchAllKindergartens({int page = 1, int perPage = 10}) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      // Parse the response body
      Map<String, dynamic> responseBody = json.decode(response.body);

      // Convert the response to a Pagination object
      return Pagination.fromJson(responseBody);
    } else {
      throw Exception('Failed to load kindergartens');
    }
  }

  Future<Pagination> fetchKindergartens(
      {int page = 1, int perPage = 10, String? name, String? state, String? city}) async {
    String url = '$baseUrl?_page=$page&_per_page=$perPage';

    if (name != null && name.isNotEmpty) url += '&name=$name';
    if (state != null && state.isNotEmpty) url += '&state=$state';
    if (city != null && city.isNotEmpty) url += '&city=$city';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Pagination.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load kindergartens');
    }
  }

  Future<Kindergarten> fetchKindergartenDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Kindergarten.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load kindergarten details');
    }
  }
}
