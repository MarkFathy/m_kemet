import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/bookmarks/domain/usecases/get_bookmarks_usecase.dart';
import 'package:m_kemet/src/features/bookmarks/domain/usecases/toggle_bookmark_usecase.dart';
import 'package:m_kemet/src/features/bookmarks/presentation/cubit/bookmarks_state.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  final GetBookmarksUseCase getBookmarksUseCase;
  final ToggleBookmarkUseCase toggleBookmarkUseCase;

  BookmarksCubit({
    required this.getBookmarksUseCase,
    required this.toggleBookmarkUseCase,
  }) : super(const BookmarksState());

  Future<void> fetchBookmarks() async {
    emit(state.copyWith(status: BookmarksStatus.loading));
    final result = await getBookmarksUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: BookmarksStatus.failure,
        errorMessage: failure.serverException.message,
      )),
      (candidates) {
        final ids = candidates.map((c) => c.id).toSet();
        emit(state.copyWith(
          status: BookmarksStatus.success,
          bookmarkedCandidates: candidates,
          bookmarkedIds: ids,
        ));
      },
    );
  }

  Future<void> toggleBookmark(CandidateEntity candidate) async {
    final candidateId = candidate.id;
    final wasBookmarked = state.isBookmarked(candidateId);
    final willBeBookmarked = !wasBookmarked;

    // 1. Instant Optimistic UI Update
    final updatedIds = Set<String>.from(state.bookmarkedIds);
    final updatedCandidates = List<CandidateEntity>.from(state.bookmarkedCandidates);

    if (willBeBookmarked) {
      updatedIds.add(candidateId);
      if (!updatedCandidates.any((c) => c.id == candidateId)) {
        updatedCandidates.add(candidate.copyWith(isSaved: true));
      }
    } else {
      updatedIds.remove(candidateId);
      updatedCandidates.removeWhere((c) => c.id == candidateId);
    }

    emit(state.copyWith(
      bookmarkedIds: updatedIds,
      bookmarkedCandidates: updatedCandidates,
    ));

    // 2. Background API Call
    final result = await toggleBookmarkUseCase(candidateId);
    result.fold(
      (failure) {
        // Rollback on failure
        final rollbackIds = Set<String>.from(state.bookmarkedIds);
        final rollbackCandidates = List<CandidateEntity>.from(state.bookmarkedCandidates);

        if (wasBookmarked) {
          rollbackIds.add(candidateId);
          if (!rollbackCandidates.any((c) => c.id == candidateId)) {
            rollbackCandidates.add(candidate.copyWith(isSaved: true));
          }
        } else {
          rollbackIds.remove(candidateId);
          rollbackCandidates.removeWhere((c) => c.id == candidateId);
        }

        emit(state.copyWith(
          bookmarkedIds: rollbackIds,
          bookmarkedCandidates: rollbackCandidates,
          errorMessage: failure.serverException.message,
        ));
      },
      (confirmedCandidate) {
        // Confirm server state if different
        if (confirmedCandidate.isSaved != willBeBookmarked) {
          final serverIds = Set<String>.from(state.bookmarkedIds);
          final serverCandidates = List<CandidateEntity>.from(state.bookmarkedCandidates);

          if (confirmedCandidate.isSaved) {
            serverIds.add(candidateId);
            if (!serverCandidates.any((c) => c.id == candidateId)) {
              serverCandidates.add(candidate.copyWith(isSaved: true));
            }
          } else {
            serverIds.remove(candidateId);
            serverCandidates.removeWhere((c) => c.id == candidateId);
          }

          emit(state.copyWith(
            bookmarkedIds: serverIds,
            bookmarkedCandidates: serverCandidates,
          ));
        }
      },
    );
  }
}
