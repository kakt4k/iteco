import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/providers/notes_provider.dart';
import 'package:mobile/widgets/input.dart';
import 'package:mobile/widgets/input_password.dart';
import 'package:mobile/di/di.dart';
import 'package:provider/provider.dart';

import '../database/db.dart';
import '../widgets/alerts.dart';

class Entrance extends StatefulWidget {
  const Entrance({super.key});

  @override
  State<Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<Entrance> {
  final _controllerLogin = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _storage = FlutterSecureStorage();
  bool _isCan = false;

  void _checkCan() {
    if (_controllerLogin.text.isNotEmpty &&
        _controllerPassword.text.isNotEmpty) {
      setState(() {
        _isCan = true;
      });
    } else {
      setState(() {
        _isCan = false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerLogin.addListener(() => _checkCan());
    _controllerPassword.addListener(() => _checkCan());
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 200
                  : 0,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                'Вход',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              height: 60,
              child: Input(controller: _controllerLogin, labelText: 'Логин'),
            ),
            Container(
              height: 60,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: InputPassword(
                controller: _controllerPassword,
                labelText: 'Пароль',
              ),
            ),
            Container(
              height: 60,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: FilledButton(
                onPressed: _isCan
                    ? () async {
                        final dio = getIt<Dio>();
                        final user = UserModel(
                          login: _controllerLogin.text,
                          password: _controllerPassword.text,
                        );
                        try {
                          final response = await dio.post(
                            '/entrance',
                            data: user.toJson(),
                          );
                          String? token = response.data['token'];
                          await _storage.write(key: 'token', value: token);
                          final responseNotes = await dio.get(
                            '/notes',
                            options: Options(
                              headers: {'Authorization': 'Bearer $token'},
                            ),
                          );
                          final textNotes = responseNotes.data['notes'];
                          for (final text in textNotes){
                            final id = await DB.insertNote(text);
                            notesProvider.addNote(id, text);
                          }
                          context.go('/home');
                        } on DioException catch (e) {
                          Alerts.showError(context, e.response?.data['detail']);
                        }
                      }
                    : null,
                child: Text('Войти'),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: Text('Регистрация'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
