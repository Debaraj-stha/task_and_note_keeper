import 'package:flutter/material.dart';
import 'package:note_app/pages/homepage.dart';
import 'package:note_app/provider/provider.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(myApp());
}
class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>provider(),child: MaterialApp(
      showSemanticsDebugger: false,
      theme: ThemeData(
        
      ),
      home: myHomePage(),
    ) ,);
   
  }
}