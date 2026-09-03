import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

enum BookmarksStatus { initial, loading, success, failure }

class BookmarksState extends Equatable {
  final BookmarksStatus status;
  final List<CandidateEntity> bookmarkedCandidates;
  final Set<String> bookmarkedIds;
  final String? errorMessage;

  const BookmarksState({
    this.status = BookmarksStatus.initial,
    this.bookmarkedCandidates = const [],
    this.bookmarkedIds = const {},
    this.errorMessage,
  });

  bool isBookmarked(String candidateId) => bookmarkedIds.contains(candidateId);

  BookmarksState copyWith({
    BookmarksStatus? status,
    List<CandidateEntity>? bookmarkedCandidates,
    Set<String>? bookmarkedIds,
    String? errorMessage,
  }) {
    return BookmarksState(
      status: status ?? this.status,
      bookmarkedCandidates: bookmarkedCandidates ?? this.bookmarkedCandidates,
      bookmarkedIds: bookmarkedIds ?? this.bookmarkedIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        bookmarkedCandidates,
        bookmarkedIds,
        errorMessage,
      ];
}
