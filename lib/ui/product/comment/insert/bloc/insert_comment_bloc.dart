import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/comment.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/comment_repository.dart';

part 'insert_comment_event.dart';
part 'insert_comment_state.dart';

class InsertCommentBloc extends Bloc<InsertCommentEvent, InsertCommentState> {
  final ICommentRepository commentRepository;
  final int productId;
  InsertCommentBloc(this.commentRepository, this.productId)
      : super(InsertCommentInitial()) {
    on<InsertCommentEvent>((event, emit) async {
      if (event is InsertCommentFormSubmit) {
        if (!AuthRepository.isUserLoggedIn()) {
          emit(InsertCommentError(
              AppException(message: 'لطفا وارد حساب کاربری خود شوید')));
        } else {
          if (event.title.isNotEmpty && event.content.isNotEmpty) {
            try {
              emit(InsertCommentLoading());
              final comment = await commentRepository.insert(
                  event.title, event.content, productId);
              emit(InsertCommentSuccess(comment));
            } catch (e) {
              emit(InsertCommentError(AppException()));
            }
          } else {
            emit(InsertCommentError(
                AppException(message: 'لطفا عنوان و نظر خود را بنویسید')));
          }
        }
      }
    });
  }
}
