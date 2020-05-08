import 'package:flutter/material.dart';

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
        accentColor: Colors.red,
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

  Widget mycard(String task){
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: ListTile(
          title: Text(
            "$task",
          ),
          onLongPress: (){},
        ),
      ),
    );
  }
  @override

  void showalertdialog(){
    showDialog(
        context: context,
        builder: (context)=> AlertDialog(
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
                autofocus: true,
              ),
              Row(children: <Widget>[
                RaisedButton(
                  onPressed: (){},
                  child: Text(
                      "ADD"
                  ),
                )
              ],)
            ],
          ),
        ),
    );
  }

  Widget build(BuildContext context) {
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
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            mycard("Meeting"),
            mycard("Go out"),
            mycard("check email")
          ],
        ),
      ),
    );

  }
}

