import 'package:pagination_with_cubit/cubit/pagination_cubit.dart';
import 'package:pagination_with_cubit/data/models/notification/alert_model.dart';
import 'package:pagination_with_cubit/data/models/notification/alert_request_model.dart';

import '../../data/models/notification/alerts_model.dart';
import '../../data/services/notification_service.dart';

class AlertCubit
    extends PaginationCubit<String, AlertModel, AlertRequestModel> {
  final NotificationService service;
  bool thereAreMoreAlerts = false;
  List<AlertModel> alerts = [];
  AlertCubit({
    required this.service,
    required super.page,
    required super.isFirstLoad,
  });

  @override
  Future<List<AlertModel>> fetchData(AlertRequestModel key) async {
    AlertsModel alertsModel = await service.fetchNotification(key);
    await Future.delayed(const Duration(seconds: 5));
    alerts = alertsModel.alerts;
    thereAreMoreAlerts = alertsModel.thereAreMoreAlerts;
    return alerts;
  }

  @override
  Future<void> loadMore() async {
    super.isFirstLoad = false;
    super.isPullToRefresh = false;
    await loadPosts(
      AlertRequestModel(
        lastAlertDate: alerts.last.alertDate,
        lastGuid: alerts.last.guid,
        pageSize: 20,
      ),
    );
  }

  @override
  Future<void> pullToRefresh() async {
    isFirstLoad = false;
    isPullToRefresh = true;
    await loadPosts(
      AlertRequestModel(
        pageSize: 20,
      ),
    );
  }

  @override
  void onLongPress(AlertModel model) {
    if (!isMultiSelctionMode) {
      isMultiSelctionMode = true;
      callMultiSelection(model);
    }
  }

  @override
  void onTap(AlertModel model) {
    if (isMultiSelctionMode) {
      callMultiSelection(model);
    }
  }

  void callMultiSelection(AlertModel model) {
    multiSelection(
        model,
        AlertRequestModel(
          lastAlertDate: alerts.last.alertDate,
          lastGuid: alerts.last.guid,
          pageSize: 20,
        ));
  }
}
