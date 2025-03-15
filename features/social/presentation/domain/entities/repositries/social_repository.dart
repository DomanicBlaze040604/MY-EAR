import 'package:dartz/dartz.dart';
import 'package:my_ear_prototype/features/social/presentation/domain/entities/community.dart';
import 'package:my_ear_prototype/features/social/presentation/domain/entities/post.dart';
import '../entities/post.dart';
import '../entities/community.dart';
import '../../core/errors/failures.dart';

abstract class SocialRepository {
  Future<Either<Failure, List<Post>>> getPosts({
    int page = 1,
    int limit = 20,
    String? communityId,
  });

  Future<Either<Failure, Post>> createPost({
    required String content,
    required PostType type,
    List<String>? mediaUrls,
    List<String>? tags,
    String? communityId,
  });

  Future<Either<Failure, void>> likePost(String postId);

  Future<Either<Failure, void>> commentOnPost({
    required String postId,
    required String content,
  });

  Future<Either<Failure, List<Community>>> getCommunities({
    int page = 1,
    int limit = 20,
    CommunityType? type,
  });

  Future<Either<Failure, Community>> joinCommunity(String communityId);

  Future<Either<Failure, Community>> leaveCommunity(String communityId);

  Future<Either<Failure, List<Post>>> getBookmarkedPosts();

  Future<Either<Failure, void>> bookmarkPost(String postId);
}

class Failure {}
