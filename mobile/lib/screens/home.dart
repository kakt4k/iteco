import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile/database/db.dart';
import 'package:mobile/widgets/input.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isCan = false;
  int? _editI;
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        setState(() {
          _isCan = true;
        });
      } else {
        setState(() {
          _isCan = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    final List notes = notesProvider.getNotes();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Заметки'),
        actions: [
          IconButton(
            onPressed: () async {
              await DB.sendInBackend();
            },
            icon: Icon(Icons.sd_storage),
          ),
          IconButton(
            onPressed: () async {
              await DB.clearNotes();
              await _storage.delete(key: 'token');
              notesProvider.clearNotes();
              context.go('/');
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, i) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color.fromRGBO(244, 244, 244, 1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(228, 232, 245, 0.6),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(notes[i]['text']),
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'Изменить',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 10),
                                  Text('Изменить'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'Удалить',
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 10),
                                  Text('Удалить'),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (String? value) {
                            if (value != null) {
                              if (value == 'Удалить') {
                                DB.deleteNote(notes[i]['id']);
                                notesProvider.deleteNote(notes[i]['id']);
                              } else {
                                setState(() {
                                  _editI = i;
                                  _focusNode.requestFocus();
                                });
                                _controller.text = notes[i]['text'];
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Input(
                      controller: _controller,
                      labelText: 'Заметка',
                      focusNode: _focusNode,
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    margin: EdgeInsets.only(left: 10),
                    child: FilledButton(
                      onPressed: !_isCan
                          ? null
                          : _editI == null
                          ? () async {
                              final id = await DB.insertNote(_controller.text);
                              notesProvider.addNote(id, _controller.text);
                              _controller.text = '';
                              _focusNode.unfocus();
                            }
                          : () async {
                              await DB.updateNote(
                                notes[_editI!]['id'],
                                _controller.text,
                              );
                              notesProvider.updateNote(
                                notes[_editI!]['id'],
                                _controller.text,
                              );
                              setState(() {
                                _editI = null;
                              });
                              _controller.text = '';
                              _focusNode.unfocus();
                            },
                      child: Icon(_editI == null ? Icons.send : Icons.edit),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
