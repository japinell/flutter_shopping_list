import "package:flutter/material.dart";
import "package:flutter_shopping_list/data/categories.dart";
import "package:flutter_shopping_list/data/dummy_items.dart";
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
  late Future<List<GroceryItem>>? _fetchItemsFuture;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchItemsFuture = _fetchItems();
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

  Future<List<GroceryItem>> _fetchItems() async {
    final databaseUrl = dotenv.env["DATABASE_URL"];
    final databaseTable = dotenv.env["DATABASE_TABLE"];
    final url = Uri.https(databaseUrl!, "$databaseTable.json");

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception("Failed to fetch grocery items. Please try again later.");
    }

    if (response.body == "null") {
      return [];
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

    return _groceryItems = jsonParsedItems;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grocery List"),
        actions: [
          IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: _fetchItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.data!.isEmpty) {
            return Center(child: Text("No items have been added yet."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, idx) => Dismissible(
              key: ValueKey(snapshot.data![idx].id),
              onDismissed: (direction) {
                _removeItem(snapshot.data![idx]);
              },
              child: ListTile(
                title: Text(snapshot.data![idx].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: snapshot.data![idx].category.color,
                ),
                trailing: Text(snapshot.data![idx].quantity.toString()),
              ),
            ),
          );
        },
      ),
    );
  }
}
