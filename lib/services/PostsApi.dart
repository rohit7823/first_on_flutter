

import '../models/Post.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

enum PostApiAction { Fetch, Delete }

class PostsApi {
  Future<List<Post>?> getPosts() async {
      var client = http.Client();
      var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
      var response = await client.get(url);
      if(response.statusCode == 200) {
        return postFromJson(response.body);
      } else {
        return null;
      }
  }

}