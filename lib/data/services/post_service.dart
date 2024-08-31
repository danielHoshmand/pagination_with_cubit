import 'dart:convert';

import 'package:http/http.dart';

class PostService {
  static const FETCH_LIMIT = 15;
  final base_url = 'https://jsonplaceholder.typicode.com/';

  Future<List<dynamic>> fetchPosts(int page) async {
    try {
      final response = await get(
          Uri.parse(base_url + 'posts?_limit=$FETCH_LIMIT&page=$page'));
      return jsonDecode(response.body) as List<dynamic>;
    } catch (e) {
      return [];
    }
  }
}
