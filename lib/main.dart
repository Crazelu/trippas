import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trippas/screens/home.dart';
import 'package:trippas/screens/loading.dart';
import 'package:hive/hive.dart';

import 'model/hive_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(TrippasAdapter());
  Hive.openBox('trippasTable');
  runApp(Trippas());
}

class Trippas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trippas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cursorColor: Colors.black,
        primarySwatch: Colors.grey,
        primaryColor: Colors.white,
        primaryColorLight: Color.fromARGB(250, 250, 250, 250),
        primaryColorDark: Colors.indigoAccent,
      ),
      routes: {
        '/': (context) => Loading(),
        'home': (context) => Home(),
      },
    );
  }
}
