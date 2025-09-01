import "package:flutter/material.dart";
import "package:flutter_shopping_list/models/grocery_item.dart";
import "package:flutter_shopping_list/widgets/new_item.dart";

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addNewItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text("No items have been added yet."));

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, idx) => ListTile(
          title: Text(_groceryItems[idx].name),
          leading: Container(
            width: 24,
            height: 24,
            color: _groceryItems[idx].category.color,
          ),
          trailing: Text(_groceryItems[idx].quantity.toString()),
        ),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, idx) => ListTile(
          title: Text(_groceryItems[idx].name),
          leading: Container(
            width: 24,
            height: 24,
            color: _groceryItems[idx].category.color,
          ),
          trailing: Text(_groceryItems[idx].quantity.toString()),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grocery List"),
        actions: [
          IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add)),
        ],
      ),
      body: content,
    );
  }
}
