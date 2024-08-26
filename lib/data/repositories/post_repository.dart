import 'package:pagination_with_cubit/data/models/post_model.dart';
import 'package:pagination_with_cubit/data/repositories/pagination_repostiroy.dart';
import 'package:pagination_with_cubit/data/services/post_service.dart';

class PostRepository extends IPaginationRepository {
  final PostService service;

  PostRepository({required this.service});

  @override
  Future<List<PostModel>> fetchData(int page) async {
    final posts = await service.fetchPosts(page);
    return posts
        .map(
          (item) => PostModel.fromJson(item),
        )
        .toList();
  }
}
