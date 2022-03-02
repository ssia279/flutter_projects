import 'package:flutter/material.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/repositories/dbhelper.dart';
import 'package:shopping_list/ui/list_item_dialog.dart';

import '../models/list_items.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  ItemsScreen(this.shoppingList);

  @override
  _ItemsScreenState createState() {
    return _ItemsScreenState(shoppingList);
  }
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList shoppingList;
  late DbHelper helper;
  List<ListItem>? items;
  ListItemDialog dialog = ListItemDialog();

  _ItemsScreenState(this.shoppingList);

  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    showData(shoppingList.id);
    return Scaffold(
      appBar: AppBar(title: Text(shoppingList.name)),
      body: ListView.builder(
          itemCount: (items != null) ? items!.length :  0,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(items![index].name),
              child: ListTile(
                title: Text(items![index].name),
                subtitle: Text(
                    'Quantity: ${items?[index].quantity} - Note: ${items?[index].note}'
                ),
                onTap: () {},
                trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {
                  showDialog(context: context, builder: (BuildContext context){
                    return dialog.buildAlert(context, items![index], false);
                  });
                },
                ),
              ),
              onDismissed: (direction) {
              String strName = items![index].name;
              helper.deleteItem(items![index]);
              setState(() {
                items?.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$strName deleted")));
              }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context) {
            return dialog.buildAlert(context, ListItem(0, shoppingList.id, '', '', ''), true);
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Future showData(int idList) async {
    await helper.openDb();
    items = await helper.getItems(idList);
    setState(() {
      items = items;
    });
  }

}