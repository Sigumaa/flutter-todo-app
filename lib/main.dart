import 'package:flutter/material.dart';

void main() {
  runApp(const MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<List<String>> todoList = [];

  void _removeTodoItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo一覧'),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(todoList[index][0]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeTodoItem(index),
                    splashRadius: 20,
                  ),
                ],
              ),
              onTap: () async {
                final newListText = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return TodoDetailPage(
                        todoTitle: todoList[index][0],
                        todoDetail: todoList[index][1]);
                  }),
                );
                if (newListText != null) {
                  setState(() {
                    todoList[index] = newListText;
                  });
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return const TodoAddPage();
            }),
          );
          if (newListText != null) {
            setState(() {
              todoList.add([newListText, '']);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoAddPage extends StatefulWidget {
  const TodoAddPage({super.key});

  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoを追加'),
      ),
      body: Container(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_text, style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 8),
            TextField(
              onSubmitted: (String value) {
                setState(() {
                  _text = value;
                });
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_text);
                },
                child: const Text('追加', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('キャンセル'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoDetailPage extends StatefulWidget {
  final String todoTitle;
  final String todoDetail;

  const TodoDetailPage(
      {super.key, required this.todoTitle, required this.todoDetail});

  @override
  _TodoDetailPageState createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  late String _todoTitle;
  late String _todoDetail;

  @override
  void initState() {
    super.initState();
    _todoTitle = widget.todoTitle;
    _todoDetail = widget.todoDetail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo詳細'),
      ),
      body: Container(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "タイトル",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onSubmitted: (String value) {
                setState(() {
                  _todoTitle = value;
                });
              },
              controller: TextEditingController.fromValue(TextEditingValue(
                text: _todoTitle,
                selection: TextSelection.fromPosition(
                    TextPosition(offset: _todoTitle.length)),
              )),
            ),
            const Padding(padding: EdgeInsets.only(top: 50)),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "詳細",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextField(
              onSubmitted: (String value) {
                setState(() {
                  _todoDetail = value;
                });
              },
              controller: TextEditingController.fromValue(TextEditingValue(
                text: _todoDetail,
                selection: TextSelection.fromPosition(
                    TextPosition(offset: _todoDetail.length)),
              )),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop([_todoTitle, _todoDetail]);
                },
                child: const Text('更新', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
