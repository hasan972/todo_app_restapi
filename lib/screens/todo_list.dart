import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app_restapi/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  //..loading variable
  bool isLoading = true;
  //....List for item......//
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      //...We need a body for show the data into app ui body..//
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            replacement: Center(child: Text('No Todo Item ',style: Theme.of(context).textTheme.headlineMedium,)),
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value){
                        if(value=='edit'){
                          //open edit page
                          navigateToEditPage(item);
                        }else if (value=='delete'){
                          //delete and remove the item
                          deleteById(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            child: Text('Edit'),
                            value: 'edit',
                          ),
                          const PopupMenuItem(
                            child: Text('Delete'),
                            value: 'delete',
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add'),
      ),
    );
  }

  //.....Navigate to edite page.........//
  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item,),
    );
   await Navigator.push(context, route);
   setState(() {
     isLoading = true; 
   });
   fetchTodo();
  }

  //.........This is the methode for go to add_page using Navigator Push..........
  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
   await Navigator.push(context, route);
   setState(() {
     isLoading = true; 
   });
   fetchTodo();
  }

  Future<void> deleteById(String id)async{
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if(response.statusCode== 200){
      //remove the item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }else{
      //show error
    }
  }

  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    //print the data into console
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;

//..This Error occure when the key name is worng......//
      //Exception has occurred.
      //_CastError (type 'Null' is not a subtype of type 'List<dynamic>' in type cast)
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
