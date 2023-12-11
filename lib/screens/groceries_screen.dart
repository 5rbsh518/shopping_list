import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item_screen.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  void _createItem() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const NewItemScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final List<GroceryItem> groceriesList = groceryItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
              onPressed: () {
                _createItem();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemCount: groceriesList.length,
        itemBuilder: ((context, index) => ListTile(
              title: Text(groceriesList[index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: groceriesList[index].category.color,
              ),
              trailing: Text(groceriesList[index].quantity.toString()),
            )),
      ),
    );
  }
}
