abstract class PaginationState<T> {}

class PostsInitial<T> extends PaginationState<T> {}

class PostsLoaded<T> extends PaginationState<T> {
  final List<T> values;

  PostsLoaded({required this.values});
}

class PostLoading<T> extends PaginationState<T> {
  final List<T> oldValues;
  final bool isFirstFetch;

  PostLoading({
    required this.oldValues,
    this.isFirstFetch = false,
  });
}
