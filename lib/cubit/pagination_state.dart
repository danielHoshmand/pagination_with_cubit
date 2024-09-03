abstract class PaginationState<HEADER, MODEL, INPUT> {
  final INPUT key;

  PaginationState({required this.key});
}

class PostsInitial<HEADER, MODEL, INPUT>
    extends PaginationState<HEADER, MODEL, INPUT> {
  PostsInitial({required super.key});
}

class PostsLoaded<H, T, I> extends PaginationState<H, T, I> {
  final Map<H, List<T>> items;
  PostsLoaded({
    required this.items,
    required super.key,
  });
}

class PostLoading<HEADER, MODEL, INPUT>
    extends PaginationState<HEADER, MODEL, INPUT> {
  final Map<HEADER, List<MODEL>> oldItems;
  final bool isFirstFetch;

  PostLoading({
    required this.oldItems,
    required super.key,
    this.isFirstFetch = false,
  });
}

class PostLoadingMore<HEADER, MODEL, INPUT>
    extends PaginationState<HEADER, MODEL, INPUT> {
  final Map<HEADER, List<MODEL>> oldItems;
  PostLoadingMore({
    required this.oldItems,
    required super.key,
  });
}
