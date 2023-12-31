import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/model/user.dart';

// V -> P (전역프로바이더, 뷰모델) -> R
class PostRepository {
  Future<ResponseDTO> fetchPostList(String jwt) async {
    try {
      // 1.통신
      final response = await dio.get("/post",
          options: Options(headers: {"Authorization": "${jwt}"}));

      // 2.ResponseDTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      // 3.ResponseDTO의 data 파싱
      List<dynamic> mapList = responseDTO.data as List<dynamic>;
      List<Post> postList = mapList.map((e) => Post.fromJson(e)).toList();

      // 4.파싱된 데이터를 다시 공통 DTO로 덮어씌우기
      responseDTO.data = postList;

      return responseDTO;
    } catch (e) {
      //200이 아니면 catch로 감
      return ResponseDTO(-1, "중복되는 유저명입니다.", null);
    }
  }

  Future<ResponseDTO> fetchPost(String jwt, PostSaveReqDTO dto) async {
    try {
      // 1.통신
      final response = await dio.post("/post",
          data: dto.toJson(),
          options: Options(headers: {"Authorization": "${jwt}"}));

      // 2.ResponseDTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      // 3.ResponseDTO의 data 파싱
      Post post = Post.fromJson(responseDTO.data);

      // 4.파싱된 데이터를 다시 공통 DTO로 덮어씌우기
      responseDTO.data = post;

      return responseDTO;
    } catch (e) {
      //200이 아니면 catch로 감
      return ResponseDTO(-1, "게시글 작성 실패", null);
    }
  }
}
