import 'package:flutter/material.dart';
import 'package:todo_app_restapi/screens/add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:navigateToAddPage,
        label: const Text('Add'),
      ),
    );
  }

  //.........This is the methode for go to add_page using Navigator Push..........
  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    Navigator.push(context, route);
  }
}
