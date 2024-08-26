import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_cubit.dart';
import 'package:pagination_with_cubit/cubit/pagination_state.dart';
import 'package:pagination_with_cubit/data/models/post_model.dart';
import 'package:pagination_with_cubit/data/repositories/post_repository.dart';
import 'package:pagination_with_cubit/presentation/section.dart';

class PaginationView<Value> extends StatelessWidget {
  final ScrollController scrollController;
  final List<Section> sections;
  PaginationView({
    super.key,
    required this.scrollController,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PaginationCubit<PostModel, PostRepository>>(context)
        .loadPosts();

    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: _paginationList(),
    );
  }

  Widget _paginationList() {
    return BlocBuilder<PaginationCubit<Value, PostRepository>,
        PaginationState<Value>>(builder: (context, state) {
      if (state is PostLoading && (state as PostLoading<Value>).isFirstFetch) {
        return _loadingIndicator();
      }

      List<Value> values = [];
      bool isLoading = false;

      if (state is PostLoading<Value>) {
        values = state.oldValues;
        isLoading = true;
      } else if (state is PostsLoaded<Value>) {
        values = state.values;
      }

      return CustomScrollView(
        controller: scrollController,
        slivers: [
          for (final section in sections)
            SliverMainAxisGroup(
              slivers: [
                section.header,
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < values.length) {
                        for (final item in section.items) {
                          return item.paginationItemView(values[index]);
                        }
                      } else if (index != values.length + 1) {
                        Timer(
                          const Duration(milliseconds: 30),
                          () {
                            scrollController.jumpTo(
                                scrollController.position.maxScrollExtent);
                          },
                        );

                        return _loadingIndicator();
                      }
                    },
                    childCount: 20,
                  ),
                ),
              ],
            ),
        ],
      );

      // return ListView.separated(
      //   controller: scrollController,
      //   itemBuilder: (context, index) {
      //     if (index < values.length) {
      //       return paginationItemView(values[index]);
      //     } else {
      //       Timer(Duration(milliseconds: 30), () {
      //         scrollController
      //             .jumpTo(scrollController.position.maxScrollExtent);
      //       });

      //       return _loadingIndicator();
      //     }
      //   },
      //   separatorBuilder: (context, index) {
      //     return Divider(
      //       color: Colors.grey[400],
      //     );
      //   },
      //   itemCount: values.length + (isLoading ? 1 : 0),
      // );
    });
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
