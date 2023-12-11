import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceriesScreen extends StatelessWidget {
  const GroceriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GroceryItem> groceriesList = groceryItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
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
