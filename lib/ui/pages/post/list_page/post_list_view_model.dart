import 'package:flutter/material.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1.창고 데이터
class PostListModel {
  List<Post> posts;
  PostListModel(this.posts);
}

// 2.창고
class PostListViewModel extends StateNotifier<PostListModel?> {
  final mContext = navigatorKey.currentContext;
  PostListViewModel(super._state, this.ref);

  Ref ref;

  Future<void> notifyInit() async {
    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().fetchPostList(sessionUser.jwt!);
    state = PostListModel(responseDTO.data);
  }

  Future<void> notifyAdd(PostSaveReqDTO dto) async {
    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().fetchPost(sessionUser.jwt!, dto);

    if (responseDTO.code == 1) {
      Post newPost = responseDTO.data as Post; // 1. dynamic(Post) -> 다운캐스팅
      // 2. 기존 상태에 데이터 추가 [전개연산자]
      List<Post> newPosts = [newPost, ...state!.posts];
      // 3.뷰모델(창고) 데이터 갱신이 완료 -> watch 구독자는 rebuild됨
      state = PostListModel(newPosts);

      Navigator.pop(mContext!);
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("게시물 작성 실패 : ${responseDTO.msg}")));
    }
  }
}

// 3.창고 관리자 (View 빌드되기 직전에 생성됨)
final postListProvider =
    StateNotifierProvider.autoDispose<PostListViewModel, PostListModel?>((ref) {
  return PostListViewModel(null, ref)..notifyInit();
});
