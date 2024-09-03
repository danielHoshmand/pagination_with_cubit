abstract class PaginationState<H, T> {}

class PostsInitial<H, T> extends PaginationState<H, T> {}

class PostsLoaded<H, T> extends PaginationState<H, T> {
  final Map<H, List<T>> items;

  PostsLoaded({required this.items});
}

class PostLoading<H, T> extends PaginationState<H, T> {
  final Map<H, List<T>> oldItems;
  final bool isFirstFetch;

  PostLoading({
    required this.oldItems,
    this.isFirstFetch = false,
  });
}

class PostLoadingMore<H, T> extends PaginationState<H, T> {
  final Map<H, List<T>> oldItems;

  PostLoadingMore({
    required this.oldItems,
  });
}
