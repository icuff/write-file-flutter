import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          storage: Storage(),
          title: 'Write on File Flutter'
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Storage storage;

  MyHomePage({Key key, this.title, @required this.storage}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String successMsg;

  @override
  void initState() {
    super.initState();
    setState(() {
      successMsg = '';
    });
  }

  void askPermission() {
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  void writeData() async {
    askPermission();

    setState(() {
      successMsg = 'Finished writing in the file.';
    });

    String message = 'Message written with Flutter';

    widget.storage.writeData(message);

    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Sending Message"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(successMsg),
            RaisedButton(
              onPressed: writeData,
              child: Text('Write in File'),
            ),
          ],
        ),
      ),
    );
  }
}

class Storage {
  Future<String> get localPath async {
    final dir = await getExternalStorageDirectory();
    return dir.path + '/Download';
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/writeFlutter.txt');
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }
}
