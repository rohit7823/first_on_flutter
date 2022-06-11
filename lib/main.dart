import 'package:first_on_flutter/blocs/counter_bloc.dart';
import 'package:first_on_flutter/blocs/posts_bloc.dart';
import 'package:first_on_flutter/services/PostsApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'models/Post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Todo App", initialRoute: '/third', routes: {
      '/': (context) => const FirstScreen(),
      '/second': (context) => const SecondScreen(),
      '/third': (context) => ThirdScreen()
    });
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  createState() => IncreseCounterScreen();
}

class IncreseCounterScreen extends State<FirstScreen> {
  final counterBloc = CounterBloc();

  @override
  Widget build(BuildContext context) {
    print('widget tree called........');
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder(
            stream: counterBloc.counterStream,
            initialData: 0,
            builder: (context, snapshot) {
              return Text("${snapshot.data}",
                  style: const TextStyle(fontSize: 32));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () =>
                    {counterBloc.eventSink.add(CounterType.INCRESE)},
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () =>
                    {counterBloc.eventSink.add(CounterType.DECRESE)},
                child: const Icon(Icons.remove),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => {counterBloc.eventSink.add(CounterType.RESET)},
                child: const Icon(Icons.redo),
              ),
            ],
          ),
          OutlinedButton(
            child: const Text("Next Screen!!"),
            onPressed: () => Navigator.pushNamed(context, '/second'),
          )
        ],
      )),
    );
  }

  @override
  void dispose() {
    counterBloc.onDispose();
    super.dispose();
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Hero(
          tag: 'imageHero',
          child: Center(
            child: Image.network('https://picsum.photos/250?image=9'),
          ),
        ),
      ),
    );
  }
}

class ThirdScreen extends StatefulWidget {
  @override
  createState() => PostsScreen();
}

class PostsScreen extends State<ThirdScreen> {
  final postsBloc = PostsBloc();

  @override
  void initState() {
    postsBloc.eventSinkPost.add(PostApiAction.Fetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SizedBox(
        child: StreamBuilder<List<Post>?>(
          stream: postsBloc.streamPost,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  cacheExtent: 100.0,
                  itemBuilder: (context, index) {
                    return Container(
                        child: Card(
                          child: Column(
                            children: [
                              Text("${snapshot.data![index].title}",
                                  style: const TextStyle(fontSize: 20)),
                              Text("${snapshot.data![index].body}",
                                  style: const TextStyle(fontSize: 10))
                            ],
                          ),
                        ));
                  });
            }
            return const Text("No items yet");
          }),
    ));
  }
}
