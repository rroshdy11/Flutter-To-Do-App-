import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks/archived_tasks.dart';
import 'package:to_do_app/modules/done_tasks/done_tasks.dart';
import 'package:to_do_app/modules/new_tasks/new_tasks.dart';

//1.creat db
//1.1. creat tables
//2.open db
//3.insert
//4.get
//5.update
//6.delete

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  Database? database;
  int currentindx = 0;
  bool isbottomsheetshown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  List<String> titles = ['New Tasks ', 'Done Tasks ', 'Archived Tasks '];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    creatDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text(titles[currentindx]),
      ),
      body: screens[currentindx],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isbottomsheetshown) {
            if (formkey.currentState!.validate()) {
              insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text)
                  .then((value) {
                Navigator.pop(context);
                isbottomsheetshown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });
              titleController.text='';
              timeController.text='';
              dateController.text='';
            }
          } else {
            scaffoldkey.currentState!.showBottomSheet((context) => Form(
                  key: formkey,
                  child: Container(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                              onTap: () {},
                              keyboardType: TextInputType.text,
                              controller: titleController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Title',
                                  prefixIcon: Icon(Icons.title)),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Title must not be empty';
                                }
                                return null;
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.datetime,
                            controller: timeController,
                            onTap: () {
                              showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                  .then((value) {
                                timeController.text =
                                    value!.format(context).toString();
                              });
                            },
                            validator: (value) {
                              if (value!.length == 0) {
                                return 'Time Must Not be Empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Task Time',
                                prefixIcon: Icon(Icons.access_time)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.datetime,
                            controller: dateController,
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2023-05-03'))
                                  .then((value) {
                                dateController.text =
                                    DateFormat.yMMMd().format(value!);
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Date Must Not be Empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'date Time',
                                prefixIcon: Icon(Icons.date_range_sharp)),
                          )
                        ],
                      ),
                    ),
                  ),
                )).closed.then((value) {
              isbottomsheetshown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
            isbottomsheetshown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 15.0,
        currentIndex: currentindx,
        onTap: (index) {
          setState(() {
            currentindx = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.table_rows_sharp), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'Archive')
        ],
      ),
    );
  }

  Future<String> getName() async {
    //Background Thread
    return 'Ahmed Ali';
  }

  void creatDatabase() async {
    database = await openDatabase('Todo.db', version: 1,
        onCreate: (database, version) async {
      //id integer
      //title String
      //data string
      //time string
      //status string
      await database
          .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY ,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('table is created');
      }).catchError((error) {
        print('ERROR HAPPENS' + error.toString());
      });
    }, onOpen: (database) {
      print('database open');
    });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print("$value insert success");
      }).catchError((error) {
        print("Error:" + error.toString());
      });
    });
  }
}
