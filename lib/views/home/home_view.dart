import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import model
import 'package:todo_list/models/home/home_model.dart';
// import controller
import 'package:todo_list/controllers/home/home_controller.dart';
import 'package:todo_list/views/home/components/buildItem.dart';
import 'package:todo_list/views/home/components/taskDescription.dart';

class HomeView extends StatefulWidget {

    //allow external child widget to access this class state.
    static _HomeViewState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_HomeViewState>());

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController itemController = TextEditingController();
  HomeController viewController = HomeController();


  @override
  void initState() {
    super.initState();
    readData();
  }

  readData() async {
    await viewController.readData().then((r){
      setState(() {
        appData.todoList = r != "" ? json.decode(r) : [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (context) => HomeModel.instance(),
      child: Consumer<HomeModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Todo List"),
              backgroundColor: Colors.blueAccent,
              centerTitle: true,
            ),
            body: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: taskDescription(
                          itemController: itemController,
                          context: context,
                          labelText: "Task"
                        )
                      ),
                      RaisedButton(
                        color: Colors.blueAccent,
                        child: Text("Add"),
                        textColor: Colors.white,
                        onPressed: () async {
                          viewController.addTodo(controller: itemController);                            

                          await viewController.refresh().then((_){
                            setState(() {});
                          });
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 10.0),
                      itemCount: appData.todoList.length,
                      itemBuilder: buildItem,
                    ), 
                    onRefresh: () async {
                      await viewController.refresh().then((_){
                        setState(() {});
                      });
                    }
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget buildItem (context, index){
  //   return Dismissible(
  //     key: UniqueKey(),
  //     direction: DismissDirection.startToEnd,
  //     onDismissed: (direction){
  //       viewController.lastRemoved = Map.from(viewController.todoList[index]);
  //       viewController.lastRemovedPos = index;
  //       viewController.todoList.removeAt(index);
          
  //       setState(() {
  //         viewController.saveData();
  //       });

  //       final snack = SnackBar(
  //         content: Text("Tastk \"${viewController.lastRemoved['title']}\" removed."),
  //         action: SnackBarAction(
  //           label: "Undo",
  //           onPressed: (){
  //             viewController.todoList.insert(viewController.lastRemovedPos, viewController.lastRemoved);
  //             setState(() {
  //               viewController.saveData();
  //             });
  //           },
  //         ),
  //         duration: Duration(seconds: 2),
  //       );

  //       Scaffold.of(context).removeCurrentSnackBar();
  //       Scaffold.of(context).showSnackBar(snack);
  //     },
  //     background: Container(
  //       color: Colors.red,
  //       child: Align(
  //         alignment: Alignment(-0.9, 0.0),
  //         child: Icon(
  //           Icons.delete,
  //           color: Colors.white,
  //         ),
  //       )
  //     ),
  //     child: CheckboxListTile(
  //         title: Text(
  //           appData.todoList[index]["title"],
  //         ),
  //         value: appData.todoList[index]["ok"],
  //         secondary: CircleAvatar(
  //           child: Icon(
  //             appData.todoList[index]["ok"] 
  //               ?
  //               Icons.check
  //               :
  //               Icons.error
  //           ),
  //         ),
  //         onChanged: (c) async {
  //           setState(() {
  //             appData.todoList[index]["ok"] = c;
  //             viewController.saveData();
  //           });

  //           await viewController.refresh().then((_){
  //             setState(() {});
  //           });
  //         },
  //       ),
  //   );
  // }

}
