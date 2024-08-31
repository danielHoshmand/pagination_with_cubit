import 'package:pagination_with_cubit/data/models/draft_model.dart';
import 'package:pagination_with_cubit/data/models/post_model.dart';
import 'package:pagination_with_cubit/data/repositories/pagination_repostiroy.dart';
import 'package:pagination_with_cubit/data/services/draft_service.dart';
import 'package:pagination_with_cubit/data/services/post_service.dart';

class DraftRepository extends IPaginationRepository {
  final LetterService service;

  DraftRepository({required this.service});

  @override
  Future<List<DraftModel>> fetchData(int page) async {
    final letters = await service.fetchLetters(page);
    return letters
        .map(
          (item) => DraftModel.fromJson(item),
        )
        .toList();
  }
}
