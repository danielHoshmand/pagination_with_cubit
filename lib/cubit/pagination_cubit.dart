import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_state.dart';

import '../data/repositories/pagination_repostiroy.dart';
import '../utils/helper/sectionabale.dart';
import "package:collection/collection.dart";

class PaginationCubit<H, T extends Sectionabale<H>, I,
    Rep extends IPaginationRepository<T, I>> extends Cubit<PaginationState> {
  I page;
  final I Function(I value) newKey;
  final Rep repository;

  PaginationCubit({
    required this.page,
    required this.newKey,
    required this.repository,
  }) : super(PaginationInitial<H, T, I>(key: page));

  void loadPosts() {
    if (state is PaginationLoading<H, T, I>) {
      return;
    }
    final currentSate = state;
    var oldValues = <H, List<T>>{};
    var key = page;
    if (currentSate is PaginationLoaded<H, T, I>) {
      oldValues = currentSate.items;
      key = newKey(currentSate.key);
    }

    emit(
      PaginationLoading<H, T, I>(
        oldItems: oldValues,
        key: key,
        isFirstFetch: key == 0,
      ),
    );

    Timer(
      const Duration(seconds: 5),
      () async {
        try {
          var data = await repository.fetchData(key);

          final newItems = data.groupListsBy(
            (element) => element.getHeader(),
          );
          final oldItems = (state as PaginationLoading<H, T, I>).oldItems;
          newItems.forEach(
            (header, items) {
              if (oldItems.containsKey(header)) {
                oldItems[header]?.addAll(items);
              } else {
                oldItems[header] = items;
              }
            },
          );
          emit(PaginationLoaded<H, T, I>(
            items: oldItems,
            key: key,
          ));
        } catch (e) {
          emit(PaginationLoadError<H, T, I>(
            key: key,
            message: 'Error',
            oldItems: oldValues,
            isInitialLoad: oldValues.isEmpty,
          ));
        }
      },
    );
  }
}
