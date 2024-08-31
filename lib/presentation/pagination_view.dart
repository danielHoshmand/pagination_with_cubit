import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_cubit.dart';
import 'package:pagination_with_cubit/cubit/pagination_state.dart';
import 'package:pagination_with_cubit/data/repositories/pagination_repostiroy.dart';
import 'package:pagination_with_cubit/presentation/section.dart';

class PaginationView<Value, Rep extends IPaginationRepository>
    extends StatelessWidget {
  final ScrollController scrollController;
  final Widget Function(Value value) paginationItemViewBuilder;
  final Widget Function(String message) hraderBuilder;

  const PaginationView({
    super.key,
    required this.scrollController,
    required this.paginationItemViewBuilder,
    required this.hraderBuilder,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PaginationCubit<Value, Rep>>(context).loadPosts();

    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: _paginationList(),
    );
  }

  Widget _paginationList() {
    return BlocBuilder<PaginationCubit<Value, Rep>, PaginationState<Value>>(
        builder: (context, state) {
      if (state is PostLoading && (state as PostLoading<Value>).isFirstFetch) {
        return _loadingIndicator();
      }

      List<Section<Value>> values = [];
      bool isLoading = false;

      if (state is PostLoading<Value>) {
        values = state.oldValues;
        isLoading = true;
      } else if (state is PostsLoaded<Value>) {
        values = state.values;
      } else if (state is PostLoadingMore<Value>) {
        values = state.oldValues;
      }

      return CustomScrollView(
        controller: scrollController,
        slivers: [
          for (var i = 0; i < values.length; i++)
            SliverMainAxisGroup(
              slivers: [
                hraderBuilder(values[i].headerMessage),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < values[i].items.length) {
                        return paginationItemViewBuilder(
                            values[i].items[index]);
                      } else if (i == values.length - 1 &&
                          state is PostLoadingMore<Value>) {
                        Timer(
                          const Duration(milliseconds: 30),
                          () {
                            scrollController.jumpTo(
                                scrollController.position.maxScrollExtent);
                          },
                        );

                        return _loadingIndicator();
                      }
                      return null;
                    },
                    childCount: values[i].items.length +
                        ((i == values.length - 1) &&
                                state is PostLoadingMore<Value>
                            ? 1
                            : 0),
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
