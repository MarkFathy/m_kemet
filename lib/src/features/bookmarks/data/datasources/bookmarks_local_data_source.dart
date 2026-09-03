import 'package:m_kemet/src/features/company/data/models/candidate_model.dart';

abstract class BookmarksLocalDataSource {
  Future<List<CandidateModel>> getBookmarks();
  Future<void> saveBookmarks(List<CandidateModel> bookmarks);
  Future<CandidateModel> toggleBookmark(String candidateId);
}

class BookmarksLocalDataSourceImpl implements BookmarksLocalDataSource {
  final List<CandidateModel> _saved = [];

  @override
  Future<List<CandidateModel>> getBookmarks() async {
    return List.unmodifiable(_saved);
  }

  @override
  Future<void> saveBookmarks(List<CandidateModel> bookmarks) async {
    _saved.clear();
    _saved.addAll(bookmarks);
  }

  @override
  Future<CandidateModel> toggleBookmark(String candidateId) async {
    final index = _saved.indexWhere((c) => c.id == candidateId);
    if (index >= 0) {
      final removed = _saved.removeAt(index);
      return CandidateModel.fromEntity(removed.copyWith(isSaved: false));
    }
    final newModel = CandidateModel(
      id: candidateId,
      name: '',
      profession: '',
      isSaved: true,
    );
    _saved.add(newModel);
    return newModel;
  }
}
