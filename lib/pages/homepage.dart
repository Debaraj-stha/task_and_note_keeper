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
  void dispose() {
    // TODO: implement dispose
    Provider.of<provider>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<provider>(context, listen: false);
    p.titleFocus.unfocus();
    p.descriptionFocus.unfocus();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(),
      body: Stack(children: [
        Positioned.fill(
          top: 50,
          child: PageView(
            controller: p.pageController,
            onPageChanged: (val) {
              p.handlePageChange();
            },
            children: [notes(), taskPage()],
          ),
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
                            if (p.currentPage == 0) {
                              p.deleteNotes();
                            } else {
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
        }),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            // color: Colors.grey,
            width: MediaQuery.of(context).size.width,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black),
              ),
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                controller: p.searchcontroller,
                focusNode: p.searchNode,
                onChanged: (value) {
                  if (p.currentPage == 0)
                    p.filterNote(value);
                  else {
                    p.filterTask(value);
                  }
                  p.resetTimer();
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    border: InputBorder.none,
                    hintText: "Search here...",
                    hintStyle: TextStyle(color: Colors.black)),
              ),
            ),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          if (p.currentPage == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => addNotePage()));
          } else {
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
