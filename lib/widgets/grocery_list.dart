import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url =
        Uri.https(dotenv.env['FIREBASE_API_URL']!, 'shopping-list.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = response.body;

        if (responseBody == null || responseBody == 'null') {
          setState(() {
            _groceryItems = [];
            _isLoading = false;
          });
          return;
        }

        final Map<String, dynamic> listData = json.decode(responseBody);
        if (listData.isEmpty) {
          setState(() {
            _groceryItems = [];
            _isLoading = false;
          });
          return;
        }

        final List<GroceryItem> _loadedItems = [];
        for (final item in listData.entries) {
          final category = categories.entries
              .firstWhere(
                (catItem) => catItem.value.title == item.value['category'],
              )
              .value;
          _loadedItems.add(
            GroceryItem(
              id: item.key,
              name: item.value['name'],
              quantity: item.value['quantity'],
              category: category,
            ),
          );
        }
        setState(() {
          _groceryItems = _loadedItems;
          _isLoading = false;
        });
      } else if (response.statusCode >= 400) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to fetch data. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'An error occurred. Please try again later.';
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );
    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.https(
        dotenv.env['FIREBASE_API_URL']!, 'shopping-list/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items added yet.'),
    );
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, index) {
            return Dismissible(
              onDismissed: (direction) {
                removeItem(_groceryItems[index]);
              },
              key: ValueKey(_groceryItems[index].id),
              child: ListTile(
                title: Text(_groceryItems[index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceryItems[index].category.color,
                ),
                trailing: Text(_groceryItems[index].quantity.toString()),
              ),
            );
          });
    }
    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
