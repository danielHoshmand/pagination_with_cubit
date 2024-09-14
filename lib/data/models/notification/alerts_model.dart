// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pagination_with_cubit/data/models/notification/alert_model.dart';

class AlertsModel {
  List<AlertModel> alerts;
  bool thereAreMoreAlerts;
  AlertsModel({
    required this.alerts,
    required this.thereAreMoreAlerts,
  });

  factory AlertsModel.fromJson(Map<String, dynamic> json) {
    return AlertsModel(
        alerts: json['Alerts']
            ?.map<AlertModel>((json) => AlertModel.fromJson(json))
            .toList(),
        thereAreMoreAlerts: json['ThereAreMoreAlerts']);
  }
}
