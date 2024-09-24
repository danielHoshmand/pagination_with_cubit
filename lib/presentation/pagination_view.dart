import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_cubit.dart';
import 'package:pagination_with_cubit/cubit/pagination_state.dart';
import 'package:collection/collection.dart';
import 'package:pagination_with_cubit/cubit/sub_cubit/alert_cubit.dart';

import '../shimmer/loading.dart';
import '../utils/helper/sectionabale.dart';

class PaginationView<HEADER, MODEL extends Sectionabale<HEADER>, KEY,
    CUBIT extends PaginationCubit<HEADER, MODEL, KEY>> extends StatelessWidget {
  final ScrollController scrollController;
  final Widget Function(MODEL value) paginationItemViewBuilder;
  final Widget Function(HEADER message)? headerBuilder;
  final Widget Function(MODEL value)? selectedItemBuilder;
  final KEY initialKey;
  final Widget Function(String message) errorBuider;
  final SliverMainAxisGroup Function(String message) loadMoreErrorSliverBuider;
  final RefreshCallback onRefresh;
  final Function(MODEL model)? onLongPress;
  final Function(MODEL model)? onTap;

  const PaginationView({
    super.key,
    required this.scrollController,
    required this.paginationItemViewBuilder,
    this.selectedItemBuilder,
    this.headerBuilder,
    required this.initialKey,
    required this.errorBuider,
    required this.loadMoreErrorSliverBuider,
    required this.onRefresh,
    this.onLongPress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CUBIT>(context).loadPosts(initialKey);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
      ),
      body: _paginationList(),
    );
  }

  Widget _paginationList() {
    return BlocBuilder<CUBIT, PaginationState>(builder: (context, state) {
      if (state is PaginationLoading &&
          (state as PaginationLoading<HEADER, MODEL, KEY>).isFirstFetch) {
        return const Loading(
          showShimmer: true,
        );
        //return _loadingIndicator();
      }

      if (state is PaginationLoadError && state.isInitialLoad) {
        return errorBuider(state.message);
      }

      Map<HEADER, List<MODEL>> values = <HEADER, List<MODEL>>{};
      List<MODEL> selectedItems = List.empty();

      if (state is PaginationLoading<HEADER, MODEL, KEY>) {
        values = state.oldItems;
        selectedItems = state.selctedItems ?? List.empty();
      } else if (state is PaginationLoaded<HEADER, MODEL, KEY>) {
        values = state.oldItems;
        selectedItems = state.selctedItems ?? List.empty();
      } else if (state is PaginationMultiSelection<HEADER, MODEL, KEY>) {
        values = state.oldItems;
        selectedItems = state.selctedItems ?? List.empty();
      } else if (state is PaginationLoadError<HEADER, MODEL, KEY>) {
        values = state.oldItems;
      }

      return RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            slivers: values.isEmpty
                ? [
                    const SliverFillRemaining(
                      child: Center(
                        child: Text('Empty list!'),
                      ),
                    )
                  ]
                : state is PaginationLoadError<HEADER, MODEL, KEY>
                    ? createSections(values, selectedItems) +
                        [loadMoreErrorSliverBuider(state.message)]
                    : state is PaginationLoading<HEADER, MODEL, KEY>
                        ? createSections(values, selectedItems) +
                            [_loadingIndicatorWithSliver()]
                        : state is PaginationMultiSelection<HEADER, MODEL, KEY>
                            ? createSections(values, selectedItems) +
                                [_loadingIndicatorWithSliver()]
                            : createSections(values, selectedItems)),
      );
    });
  }

  List<SliverMainAxisGroup> createSections(
      Map<HEADER, List<MODEL>> values, List<MODEL> selectedItems) {
    return values.keys.mapIndexed(
      (i, element) {
        return SliverMainAxisGroup(
          slivers: [
            headerBuilder == null
                ? const SliverToBoxAdapter()
                : headerBuilder!(element),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    child: selectedItems.contains(values[element]![index])
                        ? selectedItemBuilder!(values[element]![index])
                        : paginationItemViewBuilder(values[element]![index]),
                    onLongPress: () {
                      onLongPress!(values[element]![index]);
                    },
                    onTap: () {
                      onTap!(values[element]![index]);
                    },
                  );
                },
                childCount: values[element]!.length,
              ),
            ),
          ],
        );
      },
    ).toList();
  }

  SliverMainAxisGroup _loadingIndicatorWithSliver() {
    return const SliverMainAxisGroup(
        slivers: [SliverToBoxAdapter(child: Loading())]);
  }
}
