import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_cubit.dart';
import 'package:pagination_with_cubit/cubit/pagination_state.dart';
import 'package:pagination_with_cubit/data/repositories/pagination_repostiroy.dart';
import 'package:collection/collection.dart';

import '../utils/helper/sectionabale.dart';

class PaginationView<H, T extends Sectionabale<H>,
    Rep extends IPaginationRepository<T>> extends StatelessWidget {
  final ScrollController scrollController;
  final Widget Function(T value) paginationItemViewBuilder;
  final Widget Function(H message)? headerBuilder;

  const PaginationView({
    super.key,
    required this.scrollController,
    required this.paginationItemViewBuilder,
    this.headerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PaginationCubit<H, T, Rep>>(context).loadPosts();

    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: _paginationList(),
    );
  }

  Widget _paginationList() {
    return BlocBuilder<PaginationCubit<H, T, Rep>, PaginationState>(
        builder: (context, state) {
      if (state is PostLoading && (state as PostLoading<H, T>).isFirstFetch) {
        return _loadingIndicator();
      }

      Map<H, List<T>> values = <H, List<T>>{};

      if (state is PostLoading<H, T>) {
        values = state.oldItems;
      } else if (state is PostsLoaded<H, T>) {
        values = state.items;
      }

      return CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          slivers: values.isEmpty
              ? [
                  SliverFillRemaining(
                    child: Center(
                      child: Text('Empty list!'),
                    ),
                  )
                ]
              : (state is PostLoading<H, T>
                  ? createSections(values, state) +
                      [_loadingIndicatorWithSliver()]
                  : createSections(values, state)));
    });
  }

  List<SliverMainAxisGroup> createSections(
      Map<H, List<T>> values, PaginationState state) {
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
    return SliverMainAxisGroup(slivers: [_loadingIndicator()]);
  }

  Widget _loadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }
}
