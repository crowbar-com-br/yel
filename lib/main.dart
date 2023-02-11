import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yel/providers/tasks.dart';
import 'package:yel/screens/manage.dart';

void main() async {
  runApp(const _LoadingPage());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yel Assistant',
      home: MultiProvider(
        providers: [
          Provider(create: (context) => TasksProvider()),
          ChangeNotifierProvider<TasksProvider>(
            create: (context) => TasksProvider(),
          ),
        ],
        child: const Manage(),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          actionsIconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.lightBlue,
        ),
        primaryColor: Colors.blue,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.lightBlueAccent,
          )),
      themeMode: ThemeMode.system,
    );
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
