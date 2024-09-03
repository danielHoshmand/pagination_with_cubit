import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_cubit.dart';
import 'package:pagination_with_cubit/cubit/pagination_state.dart';
import 'package:pagination_with_cubit/data/models/draft_model.dart';
import 'package:pagination_with_cubit/data/models/post_model.dart';
import 'package:pagination_with_cubit/data/repositories/draft_repository.dart';
import 'package:pagination_with_cubit/data/repositories/post_repository.dart';
import 'package:pagination_with_cubit/data/services/draft_service.dart';
import 'package:pagination_with_cubit/data/services/post_service.dart';
import 'package:pagination_with_cubit/presentation/draft_screen.dart';
import 'package:pagination_with_cubit/presentation/draft_screen.dart';

void main() {
  runApp(PaginationWithCubitApp(
    postRepository: PostRepository(
      service: PostService(),
    ),
    letterRepository: DraftRepository(
      service: LetterService(),
    ),
  ));
}

class PaginationWithCubitApp extends StatelessWidget {
  final PostRepository postRepository;
  final DraftRepository letterRepository;

  const PaginationWithCubitApp({
    super.key,
    required this.postRepository,
    required this.letterRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) =>
            //     PaginationCubit<PostModel, PostRepository>(postRepository),
            // child: PostView(),
            PaginationCubit<String, DraftModel, DraftRepository>(
                letterRepository),
        child: const DraftView(),
      ),
    );
  }
}
