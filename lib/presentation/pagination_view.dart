import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_cubit.dart';
import 'package:pagination_with_cubit/cubit/pagination_state.dart';
import 'package:pagination_with_cubit/data/repositories/pagination_repostiroy.dart';
import 'package:collection/collection.dart';

import '../utils/helper/sectionabale.dart';

class PaginationView<HEADER, MODEL extends Sectionabale<HEADER>, KEY,
    REP extends IPaginationRepository<MODEL, KEY>> extends StatelessWidget {
  final ScrollController scrollController;
  final Widget Function(MODEL value) paginationItemViewBuilder;
  final Widget Function(HEADER message)? headerBuilder;
  final KEY initialKey;
  final Widget Function(String message) errorBuider;
  final SliverMainAxisGroup Function(String message) loadMoreErrorSliverBuider;

  const PaginationView({
    super.key,
    required this.scrollController,
    required this.paginationItemViewBuilder,
    this.headerBuilder,
    required this.initialKey,
    required this.errorBuider,
    required this.loadMoreErrorSliverBuider,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PaginationCubit<HEADER, MODEL, KEY, REP>>(context)
        .loadPosts();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
      ),
      body: _paginationList(),
    );
  }

  Widget _paginationList() {
    return BlocBuilder<PaginationCubit<HEADER, MODEL, KEY, REP>,
        PaginationState>(builder: (context, state) {
      if (state is PaginationLoading &&
          (state as PaginationLoading<HEADER, MODEL, KEY>).isFirstFetch) {
        return _loadingIndicator();
      }

      if (state is PaginationLoadError && state.isInitialLoad) {
        return errorBuider(state.message);
      }

      Map<HEADER, List<MODEL>> values = <HEADER, List<MODEL>>{};

      if (state is PaginationLoading<HEADER, MODEL, KEY>) {
        values = state.oldItems;
      } else if (state is PaginationLoaded<HEADER, MODEL, KEY>) {
        values = state.items;
      } else if (state is PaginationLoadError<HEADER, MODEL, KEY>) {
        values = state.oldItems;
      }

      return RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 5));
        },
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
                    ? createSections(values, state) +
                        [loadMoreErrorSliverBuider(state.message)]
                    : (state is PaginationLoading<HEADER, MODEL, KEY>
                        ? createSections(values, state) +
                            [_loadingIndicatorWithSliver()]
                        : createSections(values, state))),
      );
    });
  }

  List<SliverMainAxisGroup> createSections(
      Map<HEADER, List<MODEL>> values, PaginationState state) {
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
                  return paginationItemViewBuilder(values[element]![index]);
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
    return SliverMainAxisGroup(
        slivers: [SliverToBoxAdapter(child: _loadingIndicator())]);
  }

  Widget _loadingIndicator() {
    return const Center(
        child: Padding(
      padding: EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    ));
  }
}
