import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_app/provider/provider.dart';
import 'package:note_app/utils/customText.dart';
import 'package:provider/provider.dart';

class singleTask extends StatelessWidget {
  singleTask(
      {super.key,
      required this.createdAt,
      required this.title,
   this.reminder= "2023-08-12",
         required this.id});
  final String title;
  final String createdAt;
  bool checkedValue = true;
  final String reminder;
  final String id;
  @override
  Widget build(BuildContext context) {
    debugPrint(DateTime.now().toString());
    final p = Provider.of<provider>(context, listen: false);
    final now = DateTime.now();
final date=DateTime.parse(reminder);
    debugPrint("reminder"+reminder);
    if(date==now)
    p.scheduleReminder(date);
   
    return InkWell(
      onDoubleTap: () {
        p.taskController.text = title;
        p.showUpdateTaskModal(createdAt, id, reminder, context);
      },
     
      onLongPress: () {
        p.selectNotes(id);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: p.isSelected(id)
                ? Color.fromARGB(255, 205, 198, 198)
                : Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<provider>(builder: (context, value, child) {
              return Checkbox(
                  value: value.getNoteCheckedValue(id),
                  onChanged: (val) {
                    value.handleCheckedBox(val ?? false, id);
                  });
            }),
            customText(
              text: title,
              weight: FontWeight.w700,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
