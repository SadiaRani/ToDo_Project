import 'package:flutter/material.dart';

class ToDoItem extends StatelessWidget {
  late String _itemName;
  late String _dateCreated;
  int? _Id;

  ToDoItem(this._itemName, this._dateCreated, {super.key});

  // Named constructor to create a ToDoItem from a map
  ToDoItem.fromMap(Map<String, dynamic> map) {
    _itemName = map["itemName"];
    _dateCreated = map["dateCreated"];
    _Id = map["id"];
  }

  String get itemName => _itemName;
  String get dateCreated => _dateCreated;
  int? get id => _Id;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "itemName": _itemName,
      "dateCreated": _dateCreated,
    };
    if (id != null) {
      map["id"] = _Id;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _itemName,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.9),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "Created on $_dateCreated",
                  style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 12.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
