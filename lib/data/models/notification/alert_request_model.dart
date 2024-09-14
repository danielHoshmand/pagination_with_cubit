import 'package:pagination_with_cubit/data/models/request_model.dart';

class AlertRequestModel implements RequestModel {
  final String? lastAlertDate;
  final String? lastGuid;
  final int pageSize;

  AlertRequestModel({
    this.lastAlertDate,
    this.lastGuid,
    required this.pageSize,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'LastAlertDate': lastAlertDate,
      'LastGuid': lastGuid,
      'PageSize': pageSize,
    };
  }
}
