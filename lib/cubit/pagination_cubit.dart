import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_state.dart';

import '../utils/helper/sectionabale.dart';
import "package:collection/collection.dart";

abstract class PaginationCubit<HEADER, MODEL extends Sectionabale<HEADER>, KEY>
    extends Cubit<PaginationState> {
  KEY page;
  bool isFirstLoad;
  bool isPullToRefresh = false;

  PaginationCubit({
    required this.page,
    required this.isFirstLoad,
  }) : super(PaginationInitial<HEADER, MODEL, KEY>(key: page));

  Future<List<MODEL>> fetchData(KEY key);
  void loadMore();
  void pullToRefresh();

  Future<void> loadPosts(KEY newKey) async {
    if (state is PaginationLoading<HEADER, MODEL, KEY>) {
      return;
    }
    final currentSate = state;
    var oldValues = <HEADER, List<MODEL>>{};
    var key = page;
    if (currentSate is PaginationLoaded<HEADER, MODEL, KEY>) {
      oldValues = currentSate.items;
      key = newKey;
    }

    if (!isPullToRefresh) {
      emit(
        PaginationLoading<HEADER, MODEL, KEY>(
          oldItems: oldValues,
          key: key,
          isFirstFetch: isFirstLoad,
        ),
      );
    }

    try {
      var data = await fetchData(key);

      final newItems = data.groupListsBy(
        (element) => element.getHeader(),
      );
      final oldItems = isPullToRefresh
          ? <HEADER, List<MODEL>>{}
          : (state as PaginationLoading<HEADER, MODEL, KEY>).oldItems;
      newItems.forEach(
        (header, items) {
          if (oldItems.containsKey(header)) {
            oldItems[header]?.addAll(items);
          } else {
            oldItems[header] = items;
          }
        },
      );
      emit(PaginationLoaded<HEADER, MODEL, KEY>(
        items: oldItems,
        key: key,
      ));
    } catch (e) {
      emit(PaginationLoadError<HEADER, MODEL, KEY>(
        key: key,
        message: 'Error',
        oldItems: oldValues,
        isInitialLoad: oldValues.isEmpty,
      ));
    }
  }
}
