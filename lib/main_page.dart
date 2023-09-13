import 'dart:convert';
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
  String fileName = 'msg.123';
  dynamic myList = const Text(
    '준비준비',
    style: TextStyle(fontSize: 40),
  );
  @override
  void initState() {
    // 비동기를 바로 쓸 수 없음
    super.initState();
    getPath().then((value) => showList());
  }

  Future<void> getPath() async {
    directory = await getApplicationSupportDirectory();
    if (directory != null) {
      filePath = '${directory!.path}/$fileName'; // 경로/경로/diary.json
    }
  }

  Future<void> deleteFile() async {
    try {
      var file = File(filePath);
      var result = file.delete().then((value) {
        print(value);
        showList();
      });
      print(result.toString());
    } catch (e) {
      print('delete error');
    }
  }

  Future<void> deleteContents(int index) async {
    try {
      // 파일을 불러옴 -> 그것을 [{},[]] -> jsondecode를 해서 List<map<dynamic>>으로 변환
      var file = File(filePath);
      var fileContents = await file.readAsString();
      var dataList = jsonDecode(fileContents) as List<dynamic>;

      // List니까 배열 조작   원하는 index번지 삭제하기
      dataList.removeAt(index);

      // List<map<dynamic>>을 jsonencode (String으로 변경) -> 다시 파일에 쓰기
      var jsondata = jsonEncode(dataList); // 변수 MAP을 다시 JSON으로 변환
      await file.writeAsString(jsondata).then((value) {
        // showList()
        showList();
      });
    } catch (e) {
      print('delete contents error');
    }
  }

  Future<void> showList() async {
    try {
      var file = File(filePath);
      if (file.existsSync()) {
        setState(() {
          myList = FutureBuilder(
            future: file.readAsString(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var d = snapshot.data; // String = [{'title':'asd'} . . . . .]
                var dataList = jsonDecode(d!) as List<dynamic>; // String -> MAP
                return ListView.separated(
                  itemBuilder: (context, index) {
                    var data = dataList[index] as Map<String, dynamic>;
                    print(data);
                    return ListTile(
                      title: Text(data['title']),
                      subtitle: Text(data['contents']),
                      trailing: IconButton(
                        onPressed: () {
                          deleteContents(index);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: dataList.length,
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        });
      } else {
        myList = const Text('파일이 없습니다.');
      }
    } catch (e) {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showList();
                  },
                  child: const Text('조회'),
                ),
                ElevatedButton(
                  onPressed: () {
                    deleteFile();
                  },
                  child: const Text('삭제'),
                )
              ],
            ),
            Expanded(child: myList),
          ],
        ),
      ),
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
          if (result == 'ok') {
            // 결과 출력
          }
        },
        child: const Icon(Icons.pest_control_outlined),
      ),
    );
  }
}
