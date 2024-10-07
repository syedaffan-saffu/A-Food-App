import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/backenddata/models/itemcarddata.dart';
import 'package:rajputfoods/utils/backenddata/models/itemcategorydata.dart';

class Itemsapi {
  static Future<List<Itemcarddata>> fetchMenu() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiUtils.modulesapiurl(false)}/index/index.php'),
          )
          .timeout(const Duration(seconds: 10)); // Timeout after 10 seconds

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
        return Itemcarddata.fromJsonList(jsonList);
      } else {
        throw Exception('Failed to load menu data');
      }
    } on SocketException {
      print('No Internet connection');
      throw Exception('No Internet connection');
    } on TimeoutException {
      print('Request timed out');
      throw Exception('Request timed out');
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load menu data');
    }
  }

  static Future<List<Itemcategorydata>> fetchMenuFiltered(
      int id, BuildContext context) async {
    final response = await http.get(
        Uri.parse('${ApiUtils.modulesapiurl(false)}/index/index.php?id=$id'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return Itemcategorydata.fromJsonList(jsonList);
    } else {
      throw Exception('Failed to load Categories');
    }
  }

  static Future<List<Itemcategorydata>> fetchMenuSearched(
      String query, BuildContext context, void Function(bool) haserror) async {
    final response = await http.get(
        Uri.parse('${ApiUtils.modulesapiurl(false)}/index/index.php?q=$query'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      print(jsonList);
      return Itemcategorydata.fromJsonList(jsonList);
    } else {
      return [];
    }
  }

  static Future<List<Itemcategorydata>> fetchcategories() async {
    final response = await http
        .get(Uri.parse('${ApiUtils.modulesapiurl(false)}/index/index.php'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return Itemcategorydata.fromJsonList(jsonList);
    } else {
      throw Exception('Failed to load album');
    }
  }
}
