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
  final List<GroceryItem> _groceriesList = [];

  void _createItem() async {
    GroceryItem? newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItemScreen()));
    if (newItem == null) {
      return;
    } else {
      _groceriesList.add(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        itemCount: _groceriesList.length,
        itemBuilder: ((context, index) => ListTile(
              title: Text(_groceriesList[index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceriesList[index].category.color,
              ),
              trailing: Text(_groceriesList[index].quantity.toString()),
            )),
      ),
    );
  }
}
