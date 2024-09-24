import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pagination_with_cubit/data/models/notification/alert_request_model.dart';
import 'package:pagination_with_cubit/data/models/notification/alerts_model.dart';

class NotificationService {
  static const fetchLimit = 15;
  final baseUrl =
      'http://r401a203.didgah.chargoon.net/api/didgah/core/common/Version/V20231130/alert/alert/GetPagedAlerts';

  Future<dynamic> fetchNotification(AlertRequestModel request) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode(request.toJson()),
        headers: {
          "Accept": "application/json",
          'Cookie':
              'ASP.NET_SessionId=zk5kbiv25zk4sn0vlnvg0m4l%24empty%24; UserDeviceIdentifier=80be7737-0681-43b2-b979-0c8b42a9f24b;',
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
