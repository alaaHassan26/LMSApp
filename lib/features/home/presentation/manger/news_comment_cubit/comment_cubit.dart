import 'package:flutter_bloc/flutter_bloc.dart';

class CommentCubit extends Cubit<List<Map<String, dynamic>>> {
  CommentCubit() : super([]);

  void addComment(String name, String pic, String message) {
    final newComment = {
      'name': name,
      'pic': pic,
      'message': message,
      'date': DateTime.now().toString(),
    };
    emit([newComment, ...state]);
  }

  void editComment(int index, String message) {
    final updatedComments = List<Map<String, dynamic>>.from(state);
    updatedComments[index]['message'] = message;
    emit(updatedComments);
  }

  void deleteComment(int index) {
    final updatedComments = List<Map<String, dynamic>>.from(state);
    updatedComments.removeAt(index);
    emit(updatedComments);
  }
}
