import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_cubit.dart';
import 'package:pagination_with_cubit/data/models/post_model.dart';
import 'package:pagination_with_cubit/presentation/pagination_view.dart';
import 'package:pagination_with_cubit/presentation/section.dart';

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

    var header = SliverAppBar(
      backgroundColor: Color.fromARGB(255, 22, 255, 92),
      pinned: true,
      floating: true,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
    );

    return PaginationView<PostModel>(
      scrollController: scrollController,
      paginationItemView: (value) {
        return _post(value, context);
      },
      header: const SliverAppBar(
        backgroundColor: Color.fromARGB(255, 192, 0, 0),
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(
            'Header 4',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
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
