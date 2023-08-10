import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_app/model/model.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

class updateNotePage extends StatefulWidget {
  const updateNotePage({super.key,required this.title,required this.description,required this.createdAt,required this.id});
final String title;
final String description;
final String createdAt;
final String id;
  @override
  State<updateNotePage> createState() => _updateTaskPageState();
}

class _updateTaskPageState extends State<updateNotePage> {

  @override
  Widget build(BuildContext context) {
      final p = Provider.of<provider>(context, listen: false);
    final textController = p.titleController;

    final descriptionController = p.descriptionController;
    textController.text=widget.title;
    descriptionController.text=widget.description;
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 1,
        
        ),
        body: Column(
          children: [inputFieldBuilder(textController, "title"),
          Expanded(child:inputFieldBuilder(descriptionController,"Description"))],
        ),
           floatingActionButton:FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: (){
          Notes note=Notes(createdAt: widget.createdAt,id:widget.id,title:textController.text,description: descriptionController.text);
         p.updateNote(note, widget.id, context);
      },child: Icon(Icons.save) ,),
    );
  }
}
Widget inputFieldBuilder(TextEditingController controller,String hint) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Card(
        margin: EdgeInsets.all(6),
          child: TextFormField(
            
        controller: controller,
      cursorColor: Colors.black,
        decoration: InputDecoration(
          
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Color.fromARGB(255, 165, 162, 162),fontSize: 18)
        ),
      )),
    );
  
}