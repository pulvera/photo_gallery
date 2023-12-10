import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> posts = [];

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  Future<void> getPosts() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/photos");
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          posts = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API 3x3'),
        backgroundColor: Colors.blue,
      ),
      body: posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Change to 3 for a 3x3 grid
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return GridTile(
            child: Image.network(posts[index]["thumbnailUrl"]),
            footer: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageViewPage(
                      imageUrl: posts[index]["url"],
                      title: posts[index]["title"],
                    ),
                  ),
                );
              },
              child: GridTileBar(
                backgroundColor: Colors.black45,
                title: Text(posts[index]["title"]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ImageViewPage extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ImageViewPage({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
