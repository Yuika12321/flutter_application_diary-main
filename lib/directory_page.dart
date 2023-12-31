import 'dart:io';

import 'package:flutter/material.dart';

class DirectoryPage extends StatefulWidget {
  List<dynamic> dataList;
  DirectoryPage({super.key, required this.dataList});

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  dynamic body = const Text('awd');

  showList() {
    body = ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(widget.dataList[index + 2]
                  .toString()
                  .split('/')[6]
                  .replaceAll('\'', '')),
              subtitle: const Text(''),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    File(widget.dataList[index + 2].path).delete();
                  });
                },
              ));
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: widget.dataList.length - 2);
  }

  @override
  Widget build(BuildContext context) {
    showList();
    return Scaffold(appBar: AppBar(title: const Text('dic')), body: body);
  }
}
