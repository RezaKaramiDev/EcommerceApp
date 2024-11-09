import 'package:nike/common/http_client.dart';
import 'package:nike/data/comment.dart';
import 'package:nike/data/source/comment_data_source.dart';

final commentRepository =
    CommentRepository(CommentRempteDataSource(httpClient));

abstract class ICommentRepository {
  Future<List<CommentEntity>> getAll({required int productId});
  Future<CommentEntity> insert(String title, String content, int productId);
}

class CommentRepository implements ICommentRepository {
  final ICommentDataSource dataSource;

  CommentRepository(this.dataSource);

  @override
  Future<List<CommentEntity>> getAll({required int productId}) =>
      dataSource.getAll(productId: productId);

  @override
  Future<CommentEntity> insert(String title, String content, int productId) =>
      dataSource.insert(title, content, productId);
}
