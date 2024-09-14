import 'dart:ffi';

import 'package:pagination_with_cubit/data/models/draft_model.dart';
import 'package:pagination_with_cubit/data/services/draft_service.dart';

class DraftRepository<I> {
  final LetterService<I> service;

  DraftRepository({required this.service});

  @override
  Future<List<DraftModel>> fetchData(I key) async {
    final draft = await service.fetchDraft(key);
    return draft
        .map(
          (item) => DraftModel.fromJson(item),
        )
        .toList();
  }
}
