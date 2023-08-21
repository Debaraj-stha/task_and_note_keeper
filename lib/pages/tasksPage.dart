import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_app/utils/singleTask.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import '../utils/customText.dart';

class taskPage extends StatelessWidget {
  const taskPage({super.key});

  @override
  Widget build(BuildContext context) {
     final p = Provider.of<provider>(context, listen: false);
     p.loadTasks();
    return Consumer<provider>(builder: (context, value, child) {
      if (value.tasks.isEmpty) {
        return Center(child: customText(text: "You do not have any task yet!"));
      } else if (value.tasks.length == 0) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if(value.filteredTasks.isNotEmpty){
            return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: value.filteredTasks.length,
            itemBuilder: (context, index) {
              final task=value.filteredTasks[index];
              String title =task.title;
              String createdAt = task.createdAt;
              String id = task.id;
              DateTime reminder = task.reminder!;
              return singleTask(
                  createdAt: createdAt, title: title.length>30? title.substring(0, 30):title,id:id,reminder:reminder.toString(),);
            });
        }
        else{
        return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: value.tasks.length,
            itemBuilder: (context, index) {
              final task=value.tasks[index];
              String title =task.title;
              String createdAt = task.createdAt;
              String id = task.id;
              DateTime reminder = task.reminder!;
              return singleTask(
                  createdAt: createdAt, title: title.length>30? title.substring(0, 30):title,id:id,reminder:reminder.toString(),);
            });
        }
      }
    });
  }
}
