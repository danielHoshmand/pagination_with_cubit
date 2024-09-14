import 'package:pagination_with_cubit/data/models/post_model.dart';
import 'package:pagination_with_cubit/data/services/post_service.dart';

class PostRepository<I> {
  final PostService service;

  PostRepository({required this.service});

  @override
  Future<List<PostModel>> fetchData(I page) async {
    // final posts = await service.fetchPosts(page);
    // return posts
    //     .map(
    //       (item) => PostModel.fromJson(item),
    //     )
    //     .toList();
    return List.empty();
  }
}
