import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_cubit.dart';
import 'package:pagination_with_cubit/cubit/pagination_state.dart';
import 'package:pagination_with_cubit/data/models/post_model.dart';
import 'package:pagination_with_cubit/data/repositories/post_repository.dart';

class PaginationView<Value> extends StatelessWidget {
  final Widget Function(Value value) paginationItemView;
  final ScrollController scrollController;
  PaginationView({
    super.key,
    required this.scrollController,
    required this.paginationItemView,
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

      return ListView.separated(
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index < values.length) {
            return paginationItemView(values[index]);
          } else {
            Timer(Duration(milliseconds: 30), () {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            });

            return _loadingIndicator();
          }
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[400],
          );
        },
        itemCount: values.length + (isLoading ? 1 : 0),
      );
    });
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
