import 'package:flutter/material.dart';
import 'package:todoapp/model/todoitem.dart';
import 'package:todoapp/util/database.dart';
import 'package:todoapp/util/date_formatter.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final DatabaseHelper db = DatabaseHelper();
  final List<ToDoItem> _itemList = <ToDoItem>[];

  @override
  void initState() {
    super.initState();
    _readNoDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (_, int index) {
                return Card(
                  color: Colors.white10,
                  child: ListTile(
                    title: _itemList[index], // Change from _itemList[index]
                    onLongPress: () {
                      debugPrint('Long pressed on item ${_itemList[index].itemName}');
                      _updateItem(_itemList[index], index);
                    },
                    trailing: Listener(
                      key: Key(_itemList[index].itemName),
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown: (pointerEvent) =>
                          _deleteNoDo(_itemList[index].id!, index), // Ensure id is not null
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1.0),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: _showFromDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFromDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Item",
                hintText: "e.g. Don't buy stuff",
                icon: Icon(Icons.note_add),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            _handleSubmitted(_textEditingController.text);
            _textEditingController.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();
    ToDoItem noDoItem = ToDoItem(text, dateFormatted());
    int savedItemId = await db.saveItem(noDoItem);
    ToDoItem? addedItem = await db.getItem(savedItemId);
    setState(() {
      _itemList.insert(0, addedItem!);
    });
  }

  void _readNoDoList() async {
    List<Map<String, dynamic>> items = await db.getItems();
    setState(() {
      _itemList.addAll(items.map((item) => ToDoItem.fromMap(item)).toList());
    });
  }

  void _deleteNoDo(int id, int index) async {
    debugPrint('Deleted Item!');
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  void _updateItem(ToDoItem item, int index) {
    _textEditingController.text = item.itemName; // Set the current value of the item to the controller
    var alert = AlertDialog(
      title: const Text("Update Item"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Item",
                hintText: "eg. Don't buy stuff",
                icon: Icon(Icons.update),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            String updatedText = _textEditingController.text;
            ToDoItem updatedItem = ToDoItem.fromMap({
              "itemName": updatedText,
              "dateCreated": dateFormatted(),
              "id": item.id,
            });

            await db.updateItem(updatedItem);
            setState(() {
              _itemList[index] = updatedItem;
            });
            Navigator.pop(context);
          },
          child: const Text("Update"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (_) {
        return alert;
      },
    );
  }


  void _handleSubmittedUpdate(int index, ToDoItem item) {
    setState(() {
      _itemList.removeWhere((element) => _itemList[index].itemName == item.itemName);
    });
  }
}

