import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/di/di.dart';
import 'package:mobile/providers/notes_provider.dart';
import 'package:mobile/screens/entrance.dart';
import 'package:mobile/screens/home.dart';
import 'package:mobile/screens/register.dart';
import 'package:provider/provider.dart';
import 'database/db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDi();

  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'token');

  final routers = GoRouter(
    initialLocation: token == null ? '/' : '/home',
    routes: [
      GoRoute(path: '/', builder: (context, state) => Entrance()),
      GoRoute(path: '/register', builder: (context, state) => Register()),
      GoRoute(path: '/home', builder: (context, state) => Home()),
    ],
  );
  List notes = await DB.getNotes();
  runApp(
    ChangeNotifierProvider(
      create: (context) => NotesProvider(notes),
      child: MaterialApp.router(
        theme: ThemeData(
          // useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        routerConfig: routers,
      ),
    ),
  );
}
