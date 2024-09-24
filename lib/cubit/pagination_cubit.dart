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
  bool isMultiSelctionMode = false;
  late KEY key;

  PaginationCubit({
    required this.page,
    required this.isFirstLoad,
  }) : super(PaginationInitial<HEADER, MODEL, KEY>(
            key: page, oldItems: <HEADER, List<MODEL>>{}));

  Future<List<MODEL>> fetchData(KEY key);
  void loadMore();
  void pullToRefresh();
  void onLongPress(MODEL model);
  void onTap(MODEL model);

  Future<void> loadPosts(KEY newKey) async {
    if (isPullToRefresh) {
      isMultiSelctionMode = false;
    }
    if (state is PaginationLoading<HEADER, MODEL, KEY>) {
      return;
    }
    final currentSate = state;
    var oldValues = <HEADER, List<MODEL>>{};
    List<MODEL> selectedItems = [];
    var key = page;
    if (currentSate is PaginationLoaded<HEADER, MODEL, KEY>) {
      oldValues = currentSate.oldItems;
      key = newKey;
      selectedItems = currentSate.selctedItems ?? [];
    } else if (currentSate is PaginationMultiSelection<HEADER, MODEL, KEY>) {
      oldValues = currentSate.oldItems;
      selectedItems = currentSate.selctedItems != null && !isPullToRefresh
          ? currentSate.selctedItems!
          : [];
      key = newKey;
    }

    if (!isPullToRefresh) {
      emit(
        PaginationLoading<HEADER, MODEL, KEY>(
          oldItems: oldValues,
          key: key,
          isFirstFetch: isFirstLoad,
          selctedItems: selectedItems,
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
          : (state as PaginationState<HEADER, MODEL, KEY>).oldItems;
      newItems.forEach(
        (header, items) {
          if (oldItems.containsKey(header)) {
            oldItems[header]?.addAll(items);
          } else {
            oldItems[header] = items;
          }
        },
      );
      if (isMultiSelctionMode) {
        emit(PaginationMultiSelection<HEADER, MODEL, KEY>(
          oldItems: oldItems,
          key: key,
          selctedItems: selectedItems,
        ));
      } else {
        emit(PaginationLoaded<HEADER, MODEL, KEY>(
          oldItems: oldItems,
          key: key,
          selctedItems: selectedItems,
        ));
      }
    } catch (e) {
      emit(PaginationLoadError<HEADER, MODEL, KEY>(
        key: key,
        message: 'Error',
        oldItems: oldValues,
        isInitialLoad: oldValues.isEmpty,
        selctedItems: selectedItems,
      ));
    }
  }

  void multiSelection(MODEL model, KEY key) {
    final oldItems = (state as PaginationState<HEADER, MODEL, KEY>).oldItems;
    var selectedItems =
        (state as PaginationState<HEADER, MODEL, KEY>).selctedItems;

    selectedItems!.contains(model)
        ? selectedItems.remove(model)
        : selectedItems.add(model);
    emit(PaginationMultiSelection<HEADER, MODEL, KEY>(
      selctedItems: selectedItems,
      oldItems: oldItems,
      key: key,
    ));
  }
}
