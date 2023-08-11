import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_app/utils/customText.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

class appBar extends StatelessWidget implements PreferredSizeWidget {
  appBar({
    super.key,
  });
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<provider>(context, listen: false);

    return Consumer<provider>(builder: (context, value, child) {
      bool isShown = value.selectedId.length <= 0 ? true : false;
      return AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: isShown
            ? null
            : InkWell(
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onTap: () {
                  p.unSelectNotes();
                },
              ),
        centerTitle: true,
        title: isShown
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: (){
                      p.changePageOnTap(0);
                    },
                    child: Container(
                      child: Icon(Icons.task),
                      color:
                          p.getCurrentPageIndex(0) ? Colors.orange : Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      p.changePageOnTap(1);
                    },
                    child: Container(
                      color:
                          p.getCurrentPageIndex(1) ? Colors.orange : Colors.black,
                      child: Icon(
                        Icons.check_box,
                      ),
                    ),
                  ),
                ],
              )
            : customText(
                text: value.selectedId.length == 1
                    ? value.selectedId.length.toString() + " item selected"
                    : value.selectedId.length.toString() + " items selected"),
        actions: [
          !isShown
              ? InkWell(
                  child: Icon(
                    Icons.list_alt,
                    color: Colors.black,
                  ),
                  onTap: () {
                    p.allNotesSelect();
                  },
                )
              : Container()
        ],
      );
    });
  }
}
