import 'package:pagination_with_cubit/presentation/section.dart';

abstract class PaginationState<T> {}

class PostsInitial<T> extends PaginationState<T> {}

class PostsLoaded<T> extends PaginationState<T> {
  final List<Section<T>> values;

  PostsLoaded({required this.values});
}

class PostLoading<T> extends PaginationState<T> {
  final List<Section<T>> oldValues;
  final bool isFirstFetch;

  PostLoading({
    required this.oldValues,
    this.isFirstFetch = false,
  });
}
