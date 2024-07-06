
import 'package:shared_preferences/shared_preferences.dart';
import '../models/items.dart';
import 'dart:convert';

class StorageUtil {
  static const String _keyItems = 'items';

  static Future<void> guardarItems(List<Item> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> itemJsonList = items.map((item) => jsonEncode(item.toJson())).toList();
    prefs.setStringList(_keyItems, itemJsonList);
  }

  static Future<List<Item>> cargarItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? itemJsonList = prefs.getStringList(_keyItems);
    if (itemJsonList != null) {
      return itemJsonList.map((itemJson) => Item.fromJson(jsonDecode(itemJson))).toList();
    }
    return [];
  }
}
