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
  void initState() {
    // TODO: implement initState
    Provider.of<provider>(context, listen: false).initialize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final p = Provider.of<provider>(context, listen: false);
    final textController = p.titleController;

    final descriptionController = p.descriptionController;
    final titleFocus=p.titleFocus;
    final descriptionFocus=p.descriptionFocus;
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 1,
        
        ),
        body: Column(
          children: [inputFieldBuilder(textController, "Task Title",titleFocus),
          Expanded(child:inputFieldBuilder(descriptionController,"Task Description",descriptionFocus))],
        ),
           floatingActionButton:FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: (){
         p.addNote(context);
         p.titleFocus.unfocus();
         p.descriptionFocus.unfocus();
      },child: Icon(Icons.save) ,),
        );
  }

  Widget inputFieldBuilder(TextEditingController controller,String hint,FocusNode focusNode) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Card(
        margin: EdgeInsets.all(6),
          child: TextFormField(
            onChanged: (value){
              Provider.of<provider>(context,listen: false).resetTimer();
            },
            focusNode:focusNode ,
            maxLength: null,
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