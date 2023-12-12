import 'package:flutter/material.dart';
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
      setState(() {
        _groceriesList.add(newItem);
      });
    }
  }

  void _removeItem(item) {
    setState(() {
      _groceriesList.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Let's go for a shopping",
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Try to add new items using the + icon on the top-right corner",
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onBackground),
            )
          ],
        ),
      ),
    );

    if (_groceriesList.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceriesList.length,
        itemBuilder: ((context, index) => Dismissible(
              onDismissed: (direction) {
                _removeItem(_groceriesList[index]);
              },
              key: ValueKey(_groceriesList[index].id),
              child: ListTile(
                title: Text(_groceriesList[index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceriesList[index].category.color,
                ),
                trailing: Text(_groceriesList[index].quantity.toString()),
              ),
            )),
      );
    }

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
        body: content);
  }
}
