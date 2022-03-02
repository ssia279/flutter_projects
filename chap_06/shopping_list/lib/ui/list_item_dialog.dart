import 'package:flutter/material.dart';
import 'package:shopping_list/repositories/dbhelper.dart';

import '../models/list_items.dart';

class ListItemDialog {
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildAlert(BuildContext context, ListItem item, bool isNew) {
    DbHelper helper = DbHelper();
    helper.openDb();
    if (!isNew) { // Editing mode
      txtName.text = item.name;
      txtQuantity.text = item.quantity;
      txtNote.text = item.note;
    }
    return AlertDialog(
      title: Text((isNew) ? 'New Shopping item' : 'Edit shopping item'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'Item Name',
              ),
            ),
            TextField(
              controller: txtQuantity,
              decoration: InputDecoration(
                hintText: 'Quantity'
              ),
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(
                hintText: 'Note'
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  item.name = txtName.text;
                  item.quantity = txtQuantity.text;
                  item.note = txtNote.text;
                  helper.insertItem(item);
                  Navigator.pop(context);
                },
                child: Text('Save Item'),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)
      ),
    );
  }
}