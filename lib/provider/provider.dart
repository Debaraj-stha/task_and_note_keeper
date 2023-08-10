import 'package:flutter/material.dart';
import 'package:note_app/controller/dbController.dart';
import 'package:note_app/utils/message.dart';
import 'package:uuid/uuid.dart';

import '../model/model.dart';
import '../utils/customText.dart';

class provider with ChangeNotifier {
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController taskController = new TextEditingController();
  PageController pageController = new PageController();
  List<Notes> _notes = [];
  List<Notes> get notes => _notes;
  List<Tasks> _tasks = [];
  List<Tasks> get tasks => _tasks;
  List<String> selectedId = [];
  Map<String, dynamic> isCheckedNotes = {};
  dbController? _dbController;
  FocusNode focusNode = FocusNode();
  int currentPage = 0;
  bool isUpdate = false;
  var uuid = Uuid();
  initialize() {
    _dbController = dbController();
  }

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    pageController.dispose();
  }

  Future<void> getNotes() async {
    try {
      initialize();
      _notes = await _dbController!.getNotes();
    } catch (e) {
      message(e.toString(), isSuccess: false);
    }
    notifyListeners();
  }

  Future<void> insertNote(Notes note) async {
    try {
      initialize();
      await _dbController!.insertNote(note).then((value) {
        if (value != null) {
          message("Notes added successfully");
          getNotes();
        }
      });
    } catch (e) {
      message(e.toString(), isSuccess: false);
    }
  }

  Future<void> updateNote(Notes note, String id, BuildContext context) async {
    try {
      initialize();
      await _dbController!.updateNotes(note, id).then((value) {
        if (value != null) {
          message("Notes updated successfully");
        }
      });
    } catch (e) {
      message(e.toString(), isSuccess: false);
    }
    getNotes();
    Navigator.pop(context);
  }

  Future<void> deleteNote(String id) async {
    try {
      initialize();
      await _dbController!.deleteNotes(id).then((value) {
        if (value != null) {
          message("Notes deleted successfully");
        }
      });
    } catch (e) {
      message(e.toString(), isSuccess: false);
    }
  }

  Future<void> loadTasks() async {
    try {
      initialize();
      _tasks = await _dbController!.getTasks();
      debugPrint(_tasks.toString());
    } catch (e) {
      message(e.toString(), isSuccess: false);
    }
    notifyListeners();
  }

  Future<void> insertTask(Tasks task, BuildContext context) async {
    try {
      initialize();
      await _dbController!.insertTask(task).then((value) {
        debugPrint(value.toString());
        if (value != null) {
          message("Task added successfully");
          loadTasks();
        }
      });
    } catch (e) {
      message(e.toString(), isSuccess: false);
    }
    Navigator.pop(context);
  }

  Future<void> updateTask(Tasks task, String id,BuildContext context) async {
    try {
      initialize();
      await _dbController!.updateTasks(task, id).then((value) {
        if (value != null) {
          message("Task updated successfully");
          loadTasks();
        }
      });
    } catch (e) {
      message(e.toString(), isSuccess: false);
    }
    Navigator.pop(context);
  }

  Future<void> deleteTask(String id) async {
    try {
      initialize();
      await _dbController!.deleteTasks(id).then((value) {
        if (value != null) {
          message("Task deleted successfully");
        }
      });
    } catch (e) {
      message(e.toString(), isSuccess: false);
    }
  }

  displayBottomSheet(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: TextFormField(
                controller: taskController,
                cursorColor: Colors.orange,
                maxLines: 4,
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type here...",
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: customText(
                        text: "Close",
                        color: Colors.white,
                      )),
                  TextButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: customText(
                      text: "ADD",
                      color: Colors.white,
                    ),
                    onPressed: () {
                      var id = uuid.v4();
                      String title = taskController.text;
                      String createdAt = DateTime.now().toString();
                      String reminder = DateTime.now().toString();
                      Tasks task = Tasks(
                          createdAt: createdAt,
                          title: title,
                          id: id,
                          reminder: reminder);
                      insertTask(task, context);
                      focusNode.unfocus();
                    },
                  )
                ],
              )
            ],
          );
        });
  }
showUpdateTaskModal(String createdAt,String id,String reminder,BuildContext context){
return  showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: TextFormField(
                controller: taskController,
                cursorColor: Colors.orange,
                maxLines: 4,
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type here...",
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: customText(
                        text: "Close",
                        color: Colors.white,
                      )),
                  TextButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: customText(
                      text: "update",
                      color: Colors.white,
                    ),
                    onPressed: () {
                     
                      String title = taskController.text;
                      Tasks task = Tasks(
                          createdAt: createdAt,
                          title: title,
                          id: id,
                          reminder: reminder);
                      updateTask(task, id,context);
                      focusNode.unfocus();
                    },
                  )
                ],
              )
            ],
          );
        });
}
  void addNote(BuildContext context) {
    var id = uuid.v4();
    String title = titleController.text;
    String description = descriptionController.text;
    String createdAt = DateTime.now().toString();
    Notes note = Notes(
        createdAt: createdAt, title: title, description: description, id: id);
    insertNote(note);
    Navigator.pop(context);
    titleController.clear();
    descriptionController.clear();
  }

  void selectNotes(String id) {
    if (selectedId.contains(id)) {
   
      handleCheckedBox(false, id);
    } else {
      handleCheckedBox(true, id);

    }
    debugPrint("long pressed");
    debugPrint(selectedId.toString());
    notifyListeners();
  }

  void unSelectNotes() {
    selectedId = [];
    notifyListeners();
  }

  void deleteNotes() {
    for (var id in selectedId) {
      deleteNote(id);
    }
    selectedId = [];
    getNotes();
    notifyListeners();
  }

  void allNotesSelect() {
    selectedId = [];
    for (var note in _notes) {
      selectedId.add(note.id);
      isCheckedNotes[note.id] = true;
    }
    notifyListeners();
  }

  bool isSelected(String id) {
    if (selectedId.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  void handleCheckedBox(bool val, String id) {
    isCheckedNotes[id] = val;
    if (selectedId.contains(id) && val == false) {
      selectedId.remove(id);
    } else {
      selectedId.add(id);
    }

    notifyListeners();
  }

  bool getNoteCheckedValue(String id) => isCheckedNotes[id] ?? false;
  void handlePageChange() {
    currentPage = pageController.page!.round();
    debugPrint(currentPage.toString());
    notifyListeners();
  }

  bool getCurrentPageIndex(int index) => index == currentPage ? true : false;
  void deleteTasks() {
    for (var id in selectedId) {
      deleteTask(id);
    }
    selectedId = [];
    loadTasks();
    notifyListeners();
  }
  
}
