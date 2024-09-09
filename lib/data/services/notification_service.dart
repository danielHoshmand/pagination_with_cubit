import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pagination_with_cubit/data/models/request_model.dart';

class NotificationService<REQUEST extends RequestModel, MODEL> {
  static const FETCH_LIMIT = 15;
  final base_url =
      'http://r401a203.didgah.chargoon.net/api/didgah/core/common/Version/V20231130/alert/alert/GetPagedAlerts';

  Future<dynamic> fetchNotification(REQUEST request) async {
    try {
      final response = await http.post(
        Uri.parse(base_url),
        body: jsonEncode(request.toJson()),
        headers: {
          "Accept": "application/json",
          'Cookie':
              'ASP.NET_SessionId=2jp5vlpnocv4ggblxutgc2s4%24empty%24; UserDeviceIdentifier=6ceb58f4-eee8-4841-a5b3-121dd7c8ff58;',
          'User-Agent': 'Android SDK built for x86_64 Android',
          'Content-Type': 'application/json',
        },
      );
      return jsonDecode(response.body) as List<dynamic>;
    } catch (e) {
      throw Exception();
    }
  }
}
