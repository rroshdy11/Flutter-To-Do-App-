import 'package:flutter/material.dart';
import 'package:to_do_app/modules/archived_tasks/archived_tasks.dart';
import 'package:to_do_app/modules/done_tasks/done_tasks.dart';
import 'package:to_do_app/modules/new_tasks/new_tasks.dart';

class HomeLayout  extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentindx=0;
  List<Widget>screens=[
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  List<String>titles=[
    'New Tasks ',
    'Done Tasks ',
    'Archived Tasks '
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[currentindx]
        ),
      ),
      body: screens[currentindx],
      floatingActionButton:FloatingActionButton(
        onPressed: (){},
        child:Icon(Icons.add,) ,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 15.0,
        currentIndex:currentindx ,
        onTap: (index){
          setState(() {
            currentindx=index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon:Icon(Icons.table_rows_sharp),
            label: 'Tasks'
          ),
          BottomNavigationBarItem(
              icon:Icon(Icons.check_circle_outline),
              label: 'Done'
          ),
          BottomNavigationBarItem(
              icon:Icon(Icons.archive_outlined),
              label: 'Archive'
          )
        ],
      ),

    );
  }
}
