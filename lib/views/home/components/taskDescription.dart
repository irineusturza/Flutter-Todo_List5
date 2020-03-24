import 'package:flutter/material.dart';
import 'package:todo_list/controllers/home/home_controller.dart';
import 'package:todo_list/views/home/home_view.dart';


Widget taskDescription ({context, index, labelText, itemController}){

    return TextField(
      controller: itemController,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.blueAccent)
      ),
    );
  }