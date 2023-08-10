import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_app/provider/provider.dart';
import 'package:provider/provider.dart';

class addNotePage extends StatefulWidget {
  const addNotePage({super.key});

  @override
  State<addNotePage> createState() => _addTaskPageState();
}

class _addTaskPageState extends State<addNotePage> {
  
  @override
  
  @override
  Widget build(BuildContext context) {
    final p = Provider.of<provider>(context, listen: false);
    final textController = p.titleController;

    final descriptionController = p.descriptionController;
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
         p.addNote(context);
      },child: Icon(Icons.save) ,),
        );
  }

  Widget inputFieldBuilder(TextEditingController controller,String hint) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Card(
        margin: EdgeInsets.all(6),
          child: TextFormField(
            
        controller: controller,
      cursorColor: Colors.orange,
        decoration: InputDecoration(
          
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Color.fromARGB(255, 165, 162, 162),fontSize: 18)
        ),
      )),
    );
  }
  
 

  
}