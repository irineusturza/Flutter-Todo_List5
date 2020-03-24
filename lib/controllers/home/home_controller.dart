import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// import model
import 'package:todo_list/models/home/home_model.dart';

class HomeController {
  
  static final HomeController _appData = new HomeController._internal();

  List todoList = [];
  Map<String, dynamic> lastRemoved;
  int lastRemovedPos;

  factory HomeController() {
    return _appData;
  }
  HomeController._internal();


  void getter(BuildContext context) {
    HomeModel viewModel = Provider.of<HomeModel>(context, listen: false);
    //TODO Add code here for getter
    viewModel.getter();
  }

  void setter(BuildContext context) {
    HomeModel viewModel = Provider.of<HomeModel>(context, listen: false);
    //TODO Add code here for setter
    viewModel.setter();
  }

  void update(BuildContext context) {
    HomeModel viewModel = Provider.of<HomeModel>(context, listen: false);
    //TODO Add code here for update
    viewModel.update();
  }

  void remove(BuildContext context) {
    HomeModel viewModel = Provider.of<HomeModel>(context, listen: false);
    //TODO Add code here for remove
    viewModel.remove();
  }

  List get_todoList(){
    return todoList;
  }

  //get local file/list
  Future<File> _getFile() async {
    //get local directory
    final directory = await getApplicationDocumentsDirectory();
    File file = File(directory.path+"/data.json");
    if(await file.exists()){
      return file;
    }else{
      File file_new = await file.create();
      return file_new;
    }
  }

  //save data
  Future<File> saveData() async {
    String data = json.encode(todoList);

    final file = await _getFile();

    return file.writeAsString(data);

  }

  //read data
  Future<String> readData() async {
    try {
      final file = await _getFile();
      return await file.length() > 0 ? await file.readAsString() : "";
    } catch (e) {
      return null;
    }
  }

  addTodo({controller}) async {
    Map<String, dynamic> newTodo = Map();
    newTodo["title"] = controller.text;
    controller.text = "";

    newTodo["ok"] = false;

    todoList.add(newTodo);

    await saveData();
  }

  deleteData({item}) async {
    print(item);
    // try {
    //   final file = await _getFile();
    //   return file.readAsString();
    // } catch (e) {
    //   return null;
    // }
  }

  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 1));

    todoList.sort((a,b){
      if(a["ok"] && !b["ok"]){
        return 1;
      }else if(!a["ok"] && b["ok"]){
        return -1;
      }else{
        return 0;
      }
    });        
    
    await saveData();
    return null;
  }

    
  

}

final appData = HomeController();