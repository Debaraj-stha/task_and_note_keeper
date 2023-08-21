import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_app/utils/customText.dart';
import 'package:note_app/utils/singleNote.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

class notes extends StatelessWidget {
  const notes({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<provider>(context, listen: false);
    p.getNotes();
    return Consumer<provider>(builder: (context, value, child) {
      if (value.notes.isEmpty) {
         return Center(child: customText(text: "You do not have any note yet"));
       
      } else if (value.notes.length == 0) {
        return Center(child: CircularProgressIndicator());
      } else {
        if(value.filteredNotes.isNotEmpty){
 return    ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: value.filteredNotes.length,
        itemBuilder: (context, index) {
          final note=value.filteredNotes[index];
          String title = note.title;
          String description =note.description;
          String createdAt = note.createdAt.toString();
          String id=note.id;
          return singleNote(
            id:id,
            title: title,
            description: description,
            createdAt: createdAt,
          );
        });
        }
        else{
          return    ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: value.notes.length,
        itemBuilder: (context, index) {
          final note=value.notes[index];
          String title = note.title;
          String description =note.description;
          String createdAt = note.createdAt.toString();
          String id=note.id;
          return singleNote(
            id:id,
            title: title,
            description: description,
            createdAt: createdAt,
          );
        });
      }
      }
    });
 
  }
}
