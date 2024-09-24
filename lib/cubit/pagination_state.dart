abstract class PaginationState<HEADER, MODEL, INPUT> {
  final INPUT? key;
  List<MODEL>? selctedItems = List.empty();
  final Map<HEADER, List<MODEL>> oldItems;

  PaginationState({
    this.key,
    this.selctedItems,
    required this.oldItems,
  });
}

class PaginationInitial<HEADER, MODEL, INPUT>
    extends PaginationState<HEADER, MODEL, INPUT> {
  PaginationInitial({required super.key, required super.oldItems});
}

class PaginationLoaded<H, T, I> extends PaginationState<H, T, I> {
  PaginationLoaded({
    required super.key,
    super.selctedItems,
    required super.oldItems,
  });
}

class PaginationLoading<HEADER, MODEL, INPUT>
    extends PaginationState<HEADER, MODEL, INPUT> {
  final bool isFirstFetch;

  PaginationLoading({
    required super.oldItems,
    required super.key,
    this.isFirstFetch = false,
    super.selctedItems,
  });
}

class PaginationLoadingMore<HEADER, MODEL, INPUT>
    extends PaginationState<HEADER, MODEL, INPUT> {
  PaginationLoadingMore({
    required super.oldItems,
    required super.key,
    super.selctedItems,
  });
}

class PaginationMultiSelection<HEADER, MODEL, INPUT>
    extends PaginationState<HEADER, MODEL, INPUT> {
  PaginationMultiSelection({
    super.selctedItems,
    super.key,
    required super.oldItems,
  });
}

class PaginationLoadError<HEADER, MODEL, INPUT>
    extends PaginationState<HEADER, MODEL, INPUT> {
  final String message;
  final bool isInitialLoad;

  PaginationLoadError({
    required super.key,
    required this.message,
    required super.oldItems,
    required this.isInitialLoad,
    super.selctedItems,
  });
}
