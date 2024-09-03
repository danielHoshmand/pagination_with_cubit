import 'dart:ffi';

import 'package:pagination_with_cubit/data/models/draft_model.dart';
import 'package:pagination_with_cubit/data/repositories/pagination_repostiroy.dart';
import 'package:pagination_with_cubit/data/services/draft_service.dart';

class DraftRepository<I> extends IPaginationRepository<DraftModel, I> {
  final LetterService<I> service;

  DraftRepository({required this.service});

  @override
  Future<List<DraftModel>> fetchData(I key) async {
    final draft = await service.fetchLetters(key);
    return draft
        .map(
          (item) => DraftModel.fromJson(item),
        )
        .toList();
  }
}
