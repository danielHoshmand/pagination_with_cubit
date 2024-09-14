import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pagination_with_cubit/data/models/notification/alert_request_model.dart';
import 'package:pagination_with_cubit/data/models/notification/alerts_model.dart';

class NotificationService {
  static const fetchLimit = 15;
  final baseUrl =
      'http://rc.didgah.chargoon.net/api/didgah/core/common/Version/V20231130/alert/alert/GetPagedAlerts';

  Future<dynamic> fetchNotification(AlertRequestModel request) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode(request.toJson()),
        headers: {
          "Accept": "application/json",
          'Cookie':
              'ASP.NET_SessionId=abk0d4ydvu02beq4jeywzkii%248G1WlHnV_1614huBZxLtbdEDzv6tntZK15XG78vIhN0%24; UserDeviceIdentifier=5659cf6a-9b0d-48cf-8293-a8db635b660c;',
          'User-Agent': 'Android SDK built for x86_64 Android',
          'Content-Type': 'application/json',
        },
      );
      var paresed = jsonDecode(response.body).cast<String, dynamic>();
      return AlertsModel.fromJson(paresed);
    } catch (e) {
      throw Exception();
    }
  }
}
