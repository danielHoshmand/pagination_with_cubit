// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pagination_with_cubit/data/models/notification/alert_model.dart';

class AlertsModel {
  List<AlertModel> alerts;
  AlertsModel({
    required this.alerts,
  });

  AlertsModel.fromJson(Map<String, dynamic> json) : alerts = json['Alerts'];
}
