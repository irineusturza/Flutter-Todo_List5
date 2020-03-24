import 'package:flutter/material.dart';
import 'package:todo_list/controllers/home/home_controller.dart';
import 'package:todo_list/views/home/home_view.dart';


Widget buildItem (context, index){
    HomeController viewController = HomeController();

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) async {
        viewController.lastRemoved = Map.from(viewController.todoList[index]);
        viewController.lastRemovedPos = index;
        viewController.todoList.removeAt(index);

        await viewController.saveData();
        HomeView.of(context).setState((){});

        final snack = SnackBar(
          content: Text("Tastk \"${viewController.lastRemoved['title']}\" removed."),
          action: SnackBarAction(
            label: "Undo",
            onPressed: () async {
              viewController.todoList.insert(viewController.lastRemovedPos, viewController.lastRemoved);
              
              await viewController.saveData();
              HomeView.of(context).setState((){});

            },
          ),
          duration: Duration(seconds: 2),
        );

        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snack);
      },
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        )
      ),
      child: CheckboxListTile(
          title: Text(
            appData.todoList[index]["title"],
          ),
          value: appData.todoList[index]["ok"],
          secondary: CircleAvatar(
            child: Icon(
              appData.todoList[index]["ok"] 
                ?
                Icons.check
                :
                Icons.error
            ),
          ),
          onChanged: (c) async {
            appData.todoList[index]["ok"] = c;
            await viewController.saveData();
            await viewController.refresh();
            HomeView.of(context).setState((){});
          },
        ),
    );
  }