import 'package:pagination_with_cubit/data/models/notification/alert_model.dart';
import 'package:pagination_with_cubit/data/models/notification/alerts_model.dart';
import 'package:pagination_with_cubit/data/models/request_model.dart';
import 'package:pagination_with_cubit/data/repositories/pagination_repostiroy.dart';

import '../services/notification_service.dart';

class NotificationRepository<I extends RequestModel>
    extends IPaginationRepository<AlertModel, I> {
  final NotificationService<I, AlertsModel> service;

  NotificationRepository({required this.service});

  @override
  Future<List<AlertModel>> fetchData(I key) async {
    final alerts = await service.fetchNotification(key);
    return alerts
        .map(
          (alerts) => AlertsModel.fromJson(alerts).alerts,
        )
        .toList();
  }
}
