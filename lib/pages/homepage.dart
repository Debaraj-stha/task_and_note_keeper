import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_app/pages/addNotePage.dart';
import 'package:note_app/utils/customText.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import '../utils/appbar.dart';
import '../utils/notes.dart';
import '../pages/tasksPage.dart';

class myHomePage extends StatefulWidget {
  const myHomePage({super.key});

  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  @override
  Widget build(BuildContext context) {
    final p = Provider.of<provider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(),
      body: Stack(children: [
        PageView(
          controller: p.pageController,
          onPageChanged: (val) {
            p.handlePageChange();
          },
          children: [notes(), taskPage()],
        ),
        Consumer<provider>(builder: (context, value, child) {
          return value.selectedId.length > 0
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () {
                            if(p.currentPage == 0){
                            p.deleteNotes();
                            }
                            else{
                              p.deleteTasks();
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 30,
                            color: Colors.red,
                          )),
                    ),
                  ))
              : Container();
        })
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          if(p.currentPage==0){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => addNotePage()));
          }
          else{
p.displayBottomSheet(context);
          }
        },
        child: customText(
          text: "+",
          color: Colors.white,
          weight: FontWeight.w700,
          size: 22,
        ),
      ),
    );
  }
}
