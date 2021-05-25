import 'package:flutter/material.dart';
import 'package:lista_de_atividade/views/principal_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Principal(),
    );
  }
}
