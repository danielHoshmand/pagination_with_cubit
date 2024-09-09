import 'package:pagination_with_cubit/data/models/request_model.dart';

class AlertRequestModel implements RequestModel {
  final String? LastAlertDate;
  final String? LastGuid;
  final int PageSize;

  AlertRequestModel({
    this.LastAlertDate,
    this.LastGuid,
    required this.PageSize,
  });

  @override
  Map<String?, dynamic> toJson() {
    var x = {
      // LastAlertDate != null ? 'LastAlertDate' : LastAlertDate: Null,
      // LastGuid != null ? 'LastGuid' : LastGuid: Null,
      'PageSize': PageSize,
    };

    return x;
  }
}
