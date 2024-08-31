import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_state.dart';
import 'package:pagination_with_cubit/presentation/section.dart';

import '../data/repositories/pagination_repostiroy.dart';

class PaginationCubit<T, Rep extends IPaginationRepository>
    extends Cubit<PaginationState<T>> {
  int page = 1;
  final Rep repository;

  PaginationCubit(this.repository) : super(PostsInitial<T>());

  void loadPosts({bool isMoreLoding = false}) {
    if (state is PostLoading<T> || state is PostLoadingMore<T>) {
      return;
    }
    final currentSate = state;
    var oldValues = <Section<T>>[];
    if (currentSate is PostsLoaded<T>) {
      oldValues = currentSate.values;
    }

    emit(
      isMoreLoding
          ? PostLoadingMore<T>(
              oldValues: oldValues,
            )
          : PostLoading<T>(
              oldValues: oldValues,
              isFirstFetch: page == 1,
            ),
    );

    Timer(
      const Duration(seconds: 5),
      () async {
        repository.fetchData(page).then(
          (newValues) {
            page++;
            var vals = newValues.map(
              (value) {
                return Section<T>(items: [value], headerMessage: 'Hello');
              },
            );
            final values = isMoreLoding
                ? (state as PostLoadingMore<T>).oldValues
                : (state as PostLoading<T>).oldValues;
            values.addAll(vals);
            emit(PostsLoaded(values: values));
          },
        );
      },
    );
  }
}
