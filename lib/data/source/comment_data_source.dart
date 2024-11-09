import 'package:dio/dio.dart';
import 'package:nike/data/comment.dart';
import 'package:nike/data/common/http_response_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});
  Future<CommentEntity> insert(String title, String content, int productId);
}

class CommentRempteDataSource
    with HttpResponseValidator
    implements ICommentDataSource {
  final Dio httpClient;

  CommentRempteDataSource(this.httpClient);

  @override
  Future<List<CommentEntity>> getAll({required int productId}) async {
    final response = await httpClient.get('comment/list?product_id=$productId');
    validateResponse(response);
    final List<CommentEntity> comments = [];
    for (var element in (response.data as List)) {
      comments.add(CommentEntity.fromJson(element));
    }
    return comments;
  }

  @override
  Future<CommentEntity> insert(
      String title, String content, int productId) async {
    final response = await httpClient.post('comment/add',
        data: {"title": title, "content": content, "product_id": productId});
    validateResponse(response);
    return CommentEntity.fromJson(response.data);
  }
}
