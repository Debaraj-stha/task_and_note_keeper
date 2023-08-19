import 'dart:core';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:note_app/controller/dbController.dart';
import 'package:note_app/pages/homepage.dart';
import 'package:note_app/utils/message.dart';
import 'package:timezone/timezone.dart';
import 'package:uuid/uuid.dart';

import '../model/model.dart';
import '../utils/customText.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

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
  FocusNode titleFocus= FocusNode();
  FocusNode descriptionFocus= FocusNode();
  int currentPage = 0;
  bool isUpdate = false;
  DateTime setReminder = DateTime(2023, 08, 11, 6, 30);
  var uuid = Uuid();
  final player = AudioPlayer();
  bool issetReminder = false;
  late Timer _typingTimer;
  initialize() {
    _dbController = dbController();
    _typingTimer = Timer(Duration(seconds: 3), () {
        if (titleFocus.hasFocus||descriptionFocus.hasFocus) {
        titleFocus.unfocus();
        descriptionFocus.unfocus();
      }
    });
  }

  void resetTimer() {
    _typingTimer.cancel();
    _typingTimer = Timer(Duration(seconds: 3), () {
      if (titleFocus.hasFocus||descriptionFocus.hasFocus) {
        titleFocus.unfocus();
        descriptionFocus.unfocus();
      }
    });
  }

  void dispose() {
    _typingTimer.cancel();
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
          titleController.clear();
          descriptionController.clear();
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
          taskController.clear();
         titleFocus.unfocus();
         descriptionFocus.unfocus();
        }
      });
    } catch (e) {
      message(e.toString(), isSuccess: false);
    }
    Navigator.pop(context);
  }

  Future<void> updateTask(Tasks task, String id, BuildContext context) async {
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
    initialize();
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
                onChanged: (value){
                  resetTimer();
                },
                controller: taskController,
                cursorColor: Colors.orange,
                maxLines: 4,
                focusNode: titleFocus,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type Task here...",
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
                      DateTime reminder = DateTime.now();
                      Tasks task = Tasks(
                          createdAt: createdAt,
                          title: title,
                          id: id,
                          reminder: reminder);
                      insertTask(task, context);
                      titleFocus.unfocus();
                    },
                  )
                ],
              )
            ],
          );
        });
  }

  showUpdateTaskModal(
      String createdAt, String id, String reminder, BuildContext context) {
        initialize();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: IconButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 188, 183, 183)),
              onPressed: () async {
                setIsReminder();
                pickDate(context);
              },
              icon: customText(
                  text: reminder != null
                      ? issetReminder
                          ? setReminder.toString()
                          : reminder
                      : "set Reminder"),
              color: Colors.white,
            ),
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
                focusNode: titleFocus,
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
                          reminder:
                              issetReminder ? setReminder : DateTime.now());
                      updateTask(task, id, context);
                      titleFocus.unfocus();
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

  void playAudio() async {
    await player.play(UrlSource(
        'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3'));
    notifyListeners();
  }

  void pauseAudio() async {
    await player.pause();
    notifyListeners();
  }

  void setIsReminder() {
    issetReminder = true;
    notifyListeners();
  }

  Future<void> pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: setReminder,
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );

    if (date != null) {
      await pickTime(context); // Wait for pickTime to complete
      setReminder = DateTime(date.year, date.month, date.day, setReminder.hour,
          setReminder.minute);
      notifyListeners();
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: setReminder.hour, minute: setReminder.minute),
    );

    if (time != null) {
      setReminder = DateTime(
        setReminder.year,
        setReminder.month,
        setReminder.day,
        time.hour,
        time.minute,
      );
      notifyListeners();
    }
  }

  changePageOnTap(int index) {
    currentPage = index;
    pageController.animateToPage(index,
        duration: Duration(microseconds: 100), curve: Curves.linear);
    notifyListeners();
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void scheduleReminder(DateTime time) async {
// Get the desired time zone
    String timeZoneName =
        "Asia/Kathmandu"; // Replace with your desired time zone
    Location timeZone = getLocation(timeZoneName);

// Convert DateTime to TZDateTime
    TZDateTime reminderTime = TZDateTime.from(time, timeZone);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      'It\'s time for your reminder!',
      reminderTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  void callbackDispatcher(BuildContext context) {
    Workmanager().executeTask((task, inputData) {
      _showNotification(context);

      return Future.value(true);
    });
  }

  void _showNotification(BuildContext context) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => myHomePage()));
    debugPrint('Notification tapped');
  }
}
