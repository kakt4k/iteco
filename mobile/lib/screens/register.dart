import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/di/di.dart';
import 'package:mobile/models/models.dart';

import '../widgets/alerts.dart';
import '../widgets/input.dart';
import '../widgets/input_password.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _controllerLogin = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerPasswordRepeat = TextEditingController();
  final _storage = FlutterSecureStorage();
  bool _isCan = false;

  void _checkCan() {
    if (_controllerLogin.text.isNotEmpty &&
        _controllerPassword.text.isNotEmpty &&
        _controllerPasswordRepeat.text.isNotEmpty) {
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
    _controllerPasswordRepeat.addListener(() => _checkCan());
  }

  @override
  Widget build(BuildContext context) {
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
                'Регистрация',
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
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: InputPassword(
                controller: _controllerPasswordRepeat,
                labelText: 'Повторите пароль',
              ),
            ),
            Container(
              height: 60,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: FilledButton(
                onPressed: _isCan
                    ? () async {
                        if (_controllerPassword.text !=
                            _controllerPasswordRepeat.text) {
                          Alerts.showError(context, 'Пароли не совпадают');
                        } else {
                          final dio = getIt<Dio>();
                          final user = UserModel(
                            login: _controllerLogin.text,
                            password: _controllerPassword.text,
                          );
                          try {
                            final response = await dio.post('/register', data: user.toJson());
                            await _storage.write(
                              key: 'token',
                              value: response.data['token'],
                            );
                            context.go('/home');
                          } on DioException catch (e) {
                            Alerts.showError(
                              context,
                              e.response?.data['detail'],
                            );
                          }
                        }
                      }
                    : null,
                child: Text('Зарегистрироваться'),
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
                  context.go('/');
                },
                child: Text('Вход'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
