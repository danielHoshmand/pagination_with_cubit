import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_state.dart';

import '../data/repositories/pagination_repostiroy.dart';
import '../utils/helper/sectionabale.dart';
import "package:collection/collection.dart";

class PaginationCubit<H, T extends Sectionabale<H>,
    Rep extends IPaginationRepository<T>> extends Cubit<PaginationState> {
  int page = 1;
  final Rep repository;

  PaginationCubit(this.repository) : super(PostsInitial<H, T>());

  void loadPosts() {
    if (state is PostLoading<H, T>) {
      return;
    }
    final currentSate = state;
    var oldValues = <H, List<T>>{};
    if (currentSate is PostsLoaded<H, T>) {
      oldValues = currentSate.items;
    }

    emit(
      PostLoading<H, T>(
        oldItems: oldValues,
        isFirstFetch: page == 1,
      ),
    );

    Timer(
      const Duration(seconds: 5),
      () async {
        var data = await repository.fetchData(page);

        final newItems = data.groupListsBy(
          (element) => element.getHeader(),
        );

        page++;
        final oldItems = (state as PostLoading<H, T>).oldItems;
        newItems.forEach(
          (header, items) {
            if (oldItems.containsKey(header)) {
              oldItems[header]?.addAll(items);
            } else {
              oldItems[header] = items;
            }
          },
        );
        emit(PostsLoaded<H, T>(items: oldItems));
      },
    );
  }
}
