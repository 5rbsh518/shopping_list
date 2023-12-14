import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item_screen.dart';
import 'package:http/http.dart' as http;

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});
  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  List<GroceryItem> _groceriesList = [];
  final log = Logger("GroceriesScreen");
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    Uri url = Uri.https(
        "shopping-list-18e38-default-rtdb.europe-west1.firebasedatabase.app",
        'shopping-list.json');
    final response = await http.get(url);
    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final Map<String, dynamic> listData = jsonDecode(response.body);
    final List<GroceryItem> loadedList = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere((element) => item.value["category"] == element.value.name)
          .value;
      loadedList.add(GroceryItem(
          id: item.key,
          name: item.value["name"],
          quantity: item.value["quantity"],
          category: category));
    }
    setState(() {
      _groceriesList = loadedList;
      _isLoading = false;
    });
  }

  void _createItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItemScreen()));

    if (newItem == null) return;
    setState(() {
      _groceriesList.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    int index = _groceriesList.indexOf(item);
    setState(() {
      _groceriesList.remove(item);
    });
    Uri url = Uri.https(
        "shopping-list-18e38-default-rtdb.europe-west1.firebasedatabase.app",
        'shopping-list/${item.id}.json/');
    final respond = await http.delete(url);
    final isError = respond.statusCode >= 400;
    if (isError) {
      log.severe(
          "Error deleting the value \nID: ${item.id}\nName: ${item.name}");
      setState(() {
        _groceriesList.insert(index, item);
      });
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(
              "Error: Could not delete ${item.name}. Please try again later")));
    }
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

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
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
