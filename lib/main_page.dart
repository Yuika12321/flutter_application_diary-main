import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_diary/add_page.dart';
import 'package:path_provider/path_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({
    super.key,
  });

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late Directory? directory;
  String filePath = '';
  @override
  void initState() {
    // 비동기를 바로 쓸 수 없음
    super.initState();
    getPath();
  }

  Future<void> getPath() async {
    directory = await getApplicationSupportDirectory();
    if (directory != null) {
      String fileName = 'msg.json';
      filePath = '${directory!.path}/$fileName'; // 경로/경로/diary.json
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text('hello'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(
                filePath: filePath,
              ),
            ),
          );
          print(result);
        },
        child: const Icon(Icons.pest_control_outlined),
      ),
    );
  }
}
