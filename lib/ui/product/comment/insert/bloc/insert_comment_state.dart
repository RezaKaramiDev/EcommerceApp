part of 'insert_comment_bloc.dart';

sealed class InsertCommentState extends Equatable {
  const InsertCommentState();

  @override
  List<Object> get props => [];
}

final class InsertCommentInitial extends InsertCommentState {
  @override
  List<Object> get props => [];
}

final class InsertCommentLoading extends InsertCommentState {}

final class InsertCommentSuccess extends InsertCommentState {
  final CommentEntity commentEntity;

  const InsertCommentSuccess(this.commentEntity);
  @override
  List<Object> get props => [commentEntity];
}

final class InsertCommentError extends InsertCommentState {
  final AppException exception;

  const InsertCommentError(this.exception);
  @override
  List<Object> get props => [exception];
}
