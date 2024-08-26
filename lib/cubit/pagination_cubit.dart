import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_state.dart';

import '../data/repositories/pagination_repostiroy.dart';

class PaginationCubit<T, Rep extends IPaginationRepository>
    extends Cubit<PaginationState<T>> {
  int page = 1;
  final Rep repository;

  PaginationCubit(this.repository) : super(PostsInitial<T>());

  void loadPosts() {
    if (state is PostLoading<T>) {
      return;
    }
    final currentSate = state;
    var oldValues = <T>[];
    if (currentSate is PostsLoaded<T>) {
      oldValues = currentSate.values;
    }

    emit(
      PostLoading<T>(
        oldValues: oldValues,
        isFirstFetch: page == 1,
      ),
    );

    Timer(
      const Duration(seconds: 5),
      () {
        repository.fetchData(page).then(
          (newValues) {
            page++;
            final values = (state as PostLoading<T>).oldValues;
            values.addAll(newValues as List<T>);
            emit(PostsLoaded(values: values));
          },
        );
      },
    );
  }
}
