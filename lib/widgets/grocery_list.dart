import "package:flutter/material.dart";
import "package:flutter_shopping_list/data/categories.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import "package:flutter_dotenv/flutter_dotenv.dart";

import "package:flutter_shopping_list/models/grocery_item.dart";
import "package:flutter_shopping_list/widgets/new_item.dart";

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

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

  void _fetchItems() async {
    final databaseUrl = dotenv.env["DATABASE_URL"];
    final databaseTable = dotenv.env["DATABASE_TABLE"];
    final url = Uri.https(databaseUrl!, "$databaseTable.json");

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        _errorMessage =
            "Failed to fetch grocery items. Please try again later.";
      });
    }

    final Map<String, dynamic> jsonGroceryItems = json.decode(response.body);
    final List<GroceryItem> jsonParsedItems = [];

    for (final item in jsonGroceryItems.entries) {
      final category = categories.entries
          .firstWhere((cat) => cat.value.name == item.value["category"])
          .value;

      jsonParsedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value["name"],
          quantity: item.value["quantity"],
          category: category,
        ),
      );
    }

    setState(() {
      _groceryItems = jsonParsedItems;
      _isLoading = false;
    });
  }

  void _removeItem(GroceryItem item) async {
    final databaseUrl = dotenv.env["DATABASE_URL"];
    final databaseTable = dotenv.env["DATABASE_TABLE"];
    final url = Uri.https(databaseUrl!, "$databaseTable/${item.id}.json");

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _errorMessage =
            "Failed to delete grocery item. Please try again later.";
      });
    }

    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text("No items have been added yet."));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, idx) => Dismissible(
          key: ValueKey(_groceryItems[idx].id),
          onDismissed: (direction) {
            _removeItem(_groceryItems[idx]);
          },
          child: ListTile(
            title: Text(_groceryItems[idx].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[idx].category.color,
            ),
            trailing: Text(_groceryItems[idx].quantity.toString()),
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      content = Center(child: Text(_errorMessage));
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
