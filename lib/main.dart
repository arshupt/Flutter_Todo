import 'package:flutter/material.dart';

import 'dbhelper.dart';

void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.blue,
      ),
      home: todo(),
    );
  }
}

class todo extends StatefulWidget {
  @override
  _todouiState createState() => _todouiState();
}

class _todouiState extends State<todo>{
  final dbhelper = Databasehelper.instance;




  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtext = "";

  String todoedited = "";
  String todoupdate = "";
  var myitems = List();
  List<Widget> children =new List<Widget>();

  void addtodo() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName : todoedited,
    };
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    todoedited = "";
    setState(() {
      validated=true;
      errtext="";
    });
  }
  void updatetodo(int id) async {
    Map<String, dynamic> row = {
      Databasehelper.columnName : todoupdate,
    };
    dbhelper.updateTodo(id,row);
    Navigator.pop(context);
    todoupdate = "";
    setState(() {
      validated=true;
      errtext="";
    });
  }


  Future<bool> query() async {
    myitems = [];
    children = [];
    var allrows = await dbhelper.queryall();
    allrows.forEach((row) {
      myitems.add(row.toString());
      children.add(Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(
              row['todo'],
            ),
            onLongPress: (){
              dbhelper.deletedata(row['id']);
              setState(() {

              });
            },
            onTap: (){
              alertDialog(row['id'],row['todo']);
            },
          ),
        ),
      ));
    });
    return Future.value(true);
  }




  @override
  void showalertdialog() {
    texteditingcontroller.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
              ),
              title: Text(
                "Add Task",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: texteditingcontroller,
                    autofocus: true,
                    onChanged: (_val){
                      todoedited = _val;
                    },
                    decoration: InputDecoration(
                      errorText: validated ? null : errtext,
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            if(texteditingcontroller.text.isEmpty){
                              setState(() {
                                errtext = "Cannot leave empty";
                                validated = false;
                              });
                            }else if(texteditingcontroller.text.length > 200){
                              setState(() {
                                errtext = "Character limit exceeded";
                              });
                            }else{
                              addtodo();
                            }
                          },
                          color: Colors.red,
                          child: Text(
                              "ADD"
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );

          }

          );
        }
    );
  }


  void alertDialog(int id,String str1) {
    texteditingcontroller.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
              ),
              title: Text(
                "Edit Task",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                      controller: texteditingcontroller..text=str1,
                      autofocus: true,

                      onChanged: (_val){

                        todoupdate = _val;
                      },
                      decoration: InputDecoration(
                        errorText: validated ? null : errtext,
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            if(texteditingcontroller.text.isEmpty){
                              setState(() {
                                errtext = "Cannot leave empty";
                                validated = false;
                              });
                            }else if(texteditingcontroller.text.length > 200){
                              setState(() {
                                errtext = "Character limit exceeded";
                              });
                            }else{
                              updatetodo(id);
                            }
                          },
                          color: Colors.red,
                          child: Text(
                              "UPDATE"
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );

          }

          );
        }
    );
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap){
        // ignore: missing_return
        if(snap.hasData == null){
          return Center(
            child: Text(
              "NO DATA",
            )
          );
        }else{
          if(myitems.length == 0){
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
              ),
              appBar: AppBar(
                title: Text("ToDo"),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              body: Center(
                child: Text(
                  "No Task Available",
                )
              )

            );
          }else{
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: showalertdialog,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.red,
                ),
                appBar: AppBar(
                  title: Text("ToDo"),
                  backgroundColor: Colors.black,
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: children,
                  ),
                ),

            );
          }
        }
      },
      future: query(),
    );

  }

}


