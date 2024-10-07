import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/utilspack2.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class SharedprefStoreItem {
//   int parsetointplus(String value) {
//     final int raw = int.parse(value) + 1;
//     return raw;
//   }

//   int parsetointminus(String value) {
//     final int raw = int.parse(value) - 1;
//     return raw;
//   }

//   Future<void> storeitem(
//       String key, String json, void Function(bool) status) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("item$key", json);
//     await prefs.setInt("noofitems", parsetointplus(key));
//     status(true);
//     print("Item added success");
//   }

//   Future<String> getitemslistjson() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> orderlists = [];
//     for (int i = 0; i <= 10; i++) {
//       String? item = prefs.getString("item$i");
//       if (item != null) {
//         orderlists.add(item);
//       }
//     }
//     String jsonlist = orderlists.toString();
//     return jsonlist;
//   }

//   Future<int> getitemsrowcount() async {
//     final prefs = await SharedPreferences.getInstance();
//     final int? ordersno = prefs.getInt("noofitems");
//     if (ordersno != null) {
//       return ordersno;
//     } else {
//       return 0;
//     }
//   }

//   Future<void> deleteitem(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove("item$key");

//     final int? rmnitems = prefs.getInt("noofitems");
//     int items = 0;
//     if (rmnitems != null) {
//       if (rmnitems > 0) {
//         items = rmnitems - 1;
//       }
//     }
//     print("orders row ::: $items");
//     await prefs.setInt("noofitems", items);
//   }
// }

class SharedprefStoreItem {
  // Method to convert string to integer and increment
  int parsetointplus(String value) {
    final int raw = int.parse(value) + 1;
    return raw;
  }

  // Method to convert string to integer and decrement
  int parsetointminus(String value) {
    final int raw = int.parse(value) - 1;
    return raw;
  }

  // Method to store an item, here key is the index as a string
  Future<void> storeItem(
      BuildContext context, String json, void Function(bool) status) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? currentItems = prefs.getStringList('itemsList') ?? [];
    if (currentItems.length < 6) {
      currentItems.add(json);
      await prefs.setStringList('itemsList', currentItems);
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Added to cart successfully!", 1));
      status(true);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Items Cart Limit Exceeded!", 1));
      status(true);
    }
  }

  // Method to get all items as a JSON string
  Future<String> getItemsListJson() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? orderLists = prefs.getStringList('itemsList') ?? [];
    return orderLists.toString();
  }

  // Method to get the count of items
  Future<int> getItemsRowCount() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? itemLists = prefs.getStringList('itemsList');
    return itemLists?.length ?? 0;
  }

  // Method to delete an item by index
  Future<void> deleteItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? currentItems = prefs.getStringList('itemsList') ?? [];
    int index = int.parse(key);
    if (index < currentItems.length) {
      currentItems.removeAt(index);
      await prefs.setStringList('itemsList', currentItems);
    }
  }

  Future<void> deleteItemList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? currentItems = prefs.getStringList('itemsList') ?? [];
    if (currentItems.isNotEmpty) {
      await prefs.remove('itemsList');
    }
  }
}

class SharedprefStoreUser {
  Future<void> storeid(String userid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userid", userid);
  }

  Future<String> getuserid() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userid') != null) {
      return prefs.getString('userid')!;
    } else {
      return "";
    }
  }

  Future<void> deleteuser(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
