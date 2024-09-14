import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/sub_cubit/alert_cubit.dart';
import 'package:pagination_with_cubit/data/models/notification/alert_request_model.dart';
import 'package:pagination_with_cubit/data/repositories/draft_repository.dart';
import 'package:pagination_with_cubit/data/repositories/post_repository.dart';
import 'package:pagination_with_cubit/data/services/draft_service.dart';
import 'package:pagination_with_cubit/data/services/notification_service.dart';
import 'package:pagination_with_cubit/data/services/post_service.dart';
import 'package:pagination_with_cubit/presentation/notification_screen.dart';

void main() {
  runApp(PaginationWithCubitApp(
    postRepository: PostRepository<int>(
      service: PostService(),
    ),
    letterRepository: DraftRepository<int>(
      service: LetterService<int>(),
    ),
  ));
}

class PaginationWithCubitApp extends StatelessWidget {
  final PostRepository postRepository;
  final DraftRepository<int> letterRepository;

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
            //     PaginationCubit<String, DraftModel, int, DraftRepository<int>>(
            //   page: 0,
            //   newKey: (value) => ++value,
            //   repository: letterRepository,
            // ),
            // PaginationCubit<String, AlertModel, AlertRequestModel,
            //     NotificationRepository<AlertRequestModel>>
            AlertCubit(
          service: NotificationService(),
          page: AlertRequestModel(pageSize: 20),
          newKey: (value) {
            return AlertRequestModel(pageSize: 20);
          },
          isFirstLoad: true,
          //repository: notificationRepository,
        ),
        child: const NotificationScreen(),
      ),
    );
  }
}
