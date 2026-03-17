import 'package:flutter/cupertino.dart';

class NotesProvider extends ChangeNotifier {
  List _notes = [];

  NotesProvider(List notes) {
    _notes = notes;
  }

  void addNote(int id, String text) {
    _notes.add({'id': id, 'text': text});
    notifyListeners();
  }

  void clearNotes() {
    _notes.clear();
    notifyListeners();
  }

  void updateNote(int id, String newText) {
    for (int i = 0; i < _notes.length; ++i) {
      if (_notes[i]['id'] == id) {
        _notes[i]['text'] = newText;
        break;
      }
    }
    notifyListeners();
  }

  void deleteNote(int id) {
    for (int i = 0; i < _notes.length; ++i) {
      if (_notes[i]['id'] == id) {
        _notes.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }

  void setNotes(List newNotes) {
    _notes = newNotes;
    notifyListeners();
  }

  List getNotes(){
    return _notes;
  }
}
