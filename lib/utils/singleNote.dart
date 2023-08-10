import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_app/pages/updateNotePage.dart';
import 'package:note_app/utils/customText.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

class singleNote extends StatelessWidget {
  const singleNote(
      {super.key,
      required this.createdAt,
      required this.title,
      required this.description,
      required this.id});
  final String title;
  final String description;
  final String createdAt;
  final String id;
  @override
  Widget build(BuildContext context) {
    final p = Provider.of<provider>(context, listen: false);

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => updateNotePage(
                    title: title,
                    description: description,
                    createdAt: createdAt,
                    id: id)));
      },
      onLongPress: () {
        p.selectNotes(id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: p.isSelected(id)
                ? Color.fromARGB(255, 205, 198, 198)
                : Colors.white,
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: title,
                  weight: FontWeight.w700,
                  size: 20,
                ),
                SizedBox(
                  height: 5,
                ),
                customText(
                  text: description.length > 70
                      ? description.substring(0, 70)
                      : description,
                ),
                SizedBox(
                  height: 5,
                ),
                customText(text: createdAt, size: 14)
              ],
            ),
          
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer<provider>(builder: (context,value,child){
                  return  Checkbox(value:value.getNoteCheckedValue(id), onChanged: (val) {
                    value.handleCheckedBox(val??false, id);
                  });
                })
               ],
            )
          ],
        ),
      ),
    );
  }
}
