abstract class PaginationState<HEADER, MODEL, INPUT> {
  final INPUT key;

  PaginationState({required this.key});
}

class PaginationInitial<HEADER, MODEL, INPUT>
    extends PaginationState<HEADER, MODEL, INPUT> {
  PaginationInitial({required super.key});
}

class PaginationLoaded<H, T, I> extends PaginationState<H, T, I> {
  final Map<H, List<T>> items;
  PaginationLoaded({
    required this.items,
    required super.key,
  });
}

class PaginationLoading<HEADER, MODEL, INPUT>
    extends PaginationState<HEADER, MODEL, INPUT> {
  final Map<HEADER, List<MODEL>> oldItems;
  final bool isFirstFetch;

  PaginationLoading({
    required this.oldItems,
    required super.key,
    this.isFirstFetch = false,
  });
}

class PaginationLoadingMore<HEADER, MODEL, INPUT>
    extends PaginationState<HEADER, MODEL, INPUT> {
  final Map<HEADER, List<MODEL>> oldItems;
  PaginationLoadingMore({
    required this.oldItems,
    required super.key,
  });
}

class PaginationLoadError<HEADER, MODEL, INPUT>
    extends PaginationState<HEADER, MODEL, INPUT> {
  final String message;
  final Map<HEADER, List<MODEL>> oldItems;
  final bool isInitialLoad;

  PaginationLoadError({
    required super.key,
    required this.message,
    required this.oldItems,
    required this.isInitialLoad,
  });
}
