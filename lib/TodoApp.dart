// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ToadoApp extends StatefulWidget {
  const ToadoApp({super.key});

  @override
  State<ToadoApp> createState() => _ToadoAppState();
}

class _ToadoAppState extends State<ToadoApp> {
  TextEditingController newTodo = TextEditingController();
  TextEditingController searchTodo = TextEditingController();
  final ScrollController listcontroller = ScrollController();
  List todoData = []; // Changed to store todo with time
  bool edit = false;
  bool searching = false;
  int? editIndex; // Make sure editIndex is nullable
  List originalData = [];

  void searchTodoData() {
    if (searchTodo.text.toString().trim().toLowerCase().isNotEmpty) {
      searching = true;
      var filterdata = [];
      todoData.forEach((element) {
        originalData.add(element);
        if (element['todo']
            .toString()
            .toLowerCase()
            .contains(searchTodo.text.toLowerCase())) {
          filterdata.add(element);
        }
      });
      todoData = filterdata;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Enter some data to search"),
          backgroundColor: Color.fromARGB(255, 195, 12, 12),
        ),
      );
    }
  }

  void deleteSearchDataFromOriginalData(deleteText){
    // print(originalData);
   originalData.removeWhere((element) => element['todo'] == deleteText);

    setState(() {
      todoData = List.from(originalData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 17, 199, 206),
          title: Text("Todo App",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 13, bottom: 8, left: 5),
                    width: MediaQuery.of(context).size.width * 0.73,
                    child: TextFormField(
                      controller: newTodo,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Enter your todos',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'eg: I work hard daily',
                        hintStyle: TextStyle(color: Colors.white),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 137, 141, 138),
                              width: 2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (newTodo.text.toString().trim().isNotEmpty) {
                        setState(() {
                          if (edit) {
                            todoData[editIndex!] = {
                              'todo': newTodo.text,
                              'time': DateTime.now()
                            };
                            edit = false;
                            editIndex = null;
                          } else {
                            if (searching) {
                              todoData.insert(0, {
                                'todo': newTodo.text,
                                'time': DateTime.now()
                              });
                              todoData = List.from(originalData);
                              searching = false;
                              originalData = [];
                            }
                            todoData.insert(0,
                                {'todo': newTodo.text, 'time': DateTime.now()});
                            if (listcontroller.hasClients) {
                              var position =
                                  listcontroller.position.minScrollExtent;
                              listcontroller.animateTo(position,
                                  duration: Duration(microseconds: 1000),
                                  curve: Curves.easeInOutBack);
                            }
                          }
                        });
                        newTodo.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Todo cannot be empty"),
                            backgroundColor: Color.fromARGB(255, 201, 6, 13),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 17, 199, 206),
                      elevation: 5,
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 11),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: edit ? Icon(Icons.edit) : Icon(Icons.add),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8, bottom: 8, left: 5),
                    width: MediaQuery.of(context).size.width * 0.73,
                    child: TextFormField(
                      controller: searchTodo,
                      enabled: searching ? false : true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Search your todo',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'eg: cricket',
                        hintStyle: TextStyle(color: Colors.white),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 137, 141, 138),
                              width: 2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (searching) {
                        searchTodo.clear();
                        todoData = List.from(originalData);
                        originalData = [];
                        searching = false;
                        setState(() {});
                      } else {
                        searchTodoData();
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 17, 199, 206),
                      elevation: 5,
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 11),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Icon(searching ? Icons.cancel : Icons.search),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: todoData.length,
                  controller: listcontroller,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color.fromARGB(66, 94, 104, 94),
                      child: ListTile(
                        title: Text(
                          todoData[index]['todo'],
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        subtitle: Text(
                          'Added on: ${todoData[index]['time'].toLocal().toString().substring(0, 19)}',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(51, 158, 158, 158),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    edit = true;
                                    editIndex = index;
                                    _editTodo(todoData[index]['todo']);
                                  });
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 5, 147, 90),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(51, 158, 158, 158),
                              child: GestureDetector(
                                onTap: () {
                                  if (searching) {
                                    var deleteSearchData = todoData[index]['todo'];
                                    // print(deleteSearchData);
                                    deleteSearchDataFromOriginalData(deleteSearchData);
                                    
                                    setState(() {
                                      
                                    todoData.removeAt(index);
                                    });
                                  }
                                  else{
                                  if (editIndex != index) {
                                    setState(() {
                                      todoData.removeAt(index);
                                    });
                                  }
                                  }
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: (editIndex == index)
                                      ? Colors.grey
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editTodo(String todoText) {
    newTodo.text = todoText;
  }
}
