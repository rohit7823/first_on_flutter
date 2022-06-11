
import 'dart:async';

import 'package:first_on_flutter/models/Post.dart';
import 'package:first_on_flutter/services/PostsApi.dart';


class PostsBloc {
  final _stateStreamController = StreamController<List<Post>?>();
  StreamSink<List<Post>?> get _streamSinkPost  => _stateStreamController.sink;
  Stream<List<Post>?> get streamPost => _stateStreamController.stream;

  final _eventStreamController = StreamController<PostApiAction>();
  StreamSink<PostApiAction> get eventSinkPost => _eventStreamController.sink;
  Stream<PostApiAction> get _eventStreamPost => _eventStreamController.stream;

  PostsBloc() {
    _eventStreamPost.listen((event) async {
        try {
          switch(event) {
            case PostApiAction.Fetch:
              var posts = await PostsApi().getPosts();
              _streamSinkPost.add(posts);
              break;
            case PostApiAction.Delete:
              _streamSinkPost.add(List.empty());
              break;
          }
        } on Exception catch(ex) {
          print("error $ex");
      }
    });
  }
}