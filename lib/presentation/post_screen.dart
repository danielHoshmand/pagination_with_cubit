import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_cubit.dart';
import 'package:pagination_with_cubit/data/models/post_model.dart';
import 'package:pagination_with_cubit/presentation/pagination_view.dart';

import '../data/repositories/post_repository.dart';

class PostView extends StatefulWidget {
  PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    setupScrollController(context);
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PaginationCubit<PostModel, PostRepository>>(context)
        .loadPosts();

    return PaginationView<PostModel>(
      scrollController: scrollController,
      paginationItemView: (value) {
        return _post(value, context);
      },
    );
  }

  Widget _post(PostModel post, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${post.id}. ${post.title}",
            style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Text(post.body)
        ],
      ),
    );
  }

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<PaginationCubit<PostModel, PostRepository>>(context)
              .loadPosts();
        }
      }
    });
  }
}
