import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  // .........Add TextEditing controller.....for title and description.......
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Decription'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: submitData,
            child: const Text('Submit'),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.amber, // Text Color
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitData() async {
    //Get The Data from
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      print('Creation Sucess');
      showSuccessMessage('Creation Success');
    } else {
      print('Creation Failed');
      print(response.body);
    }
    //Submit Data to The surver
    //Show success or fail message based on status
  }

  void showSuccessMessage(String message) {
    final snackbar = SnackBar(
      content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
