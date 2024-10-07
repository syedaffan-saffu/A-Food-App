import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/backenddata/models/orderrequestdata.dart';
import 'package:rajputfoods/utils/backenddata/models/ordersdata.dart';

class OrdersApi {
  static Future<void> sendOrderRequest(
      OrderRequest orderRequest,
      void Function(String) orderid,
      void Function(bool) issuccess,
      void Function(bool) haserror) async {
    final url = Uri.parse('${ApiUtils.modulesapiurl(false)}/order/order.php');

    final body = jsonEncode(orderRequest.toJson());

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Request successful');
        final raworderid = getorderid(response.body);
        orderid(raworderid);
        issuccess(true);
      } else {
        print('Request failed with status: ${response.statusCode}');
        haserror(true);
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

  static String getorderid(String data) {
    Map<String, dynamic> json = jsonDecode(data);
    final String orderid = json['order_id'].toString();
    return orderid;
  }

  static Future<List<OrderlistData>> fetchorderlist(String id) async {
    final response = await http.get(Uri.parse(
        '${ApiUtils.modulesapiurl(false)}/order/order_list.php?id=$id'));
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return OrderlistData.fromJsonList(jsonList);
    } else {
      return [];
    }
  }

  static Future<List<OrderItemDetails>> fetchorderitemslist(String id) async {
    final response = await http.get(Uri.parse(
        '${ApiUtils.modulesapiurl(false)}/order/order_details.php?id=$id'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return OrderItemDetails.fromJsonList(jsonList);
    } else {
      return [];
    }
  }

  static Future<List<OrderStatusData>> fetchstatuslist(String id) async {
    final response = await http.get(Uri.parse(
        '${ApiUtils.modulesapiurl(false)}/order/track_order.php?id=$id'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return OrderStatusData.fromJsonList(jsonList);
    } else {
      throw Exception('Failed to load Status');
    }
  }

  static Future<void> sendOrderReview(OrderReview orderReview,
      void Function(bool) issuccess, void Function(bool) haserror) async {
    final url =
        Uri.parse('${ApiUtils.modulesapiurl(false)}/index/get_review.php');

    final body = jsonEncode(orderReview.toJson());

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Review successful');
        issuccess(true);
      } else {
        print('Review failed with status: ${response.statusCode}');
        haserror(true);
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

  static Future<bool> cancelorder(String id) async {
    final response = await http.get(Uri.parse(
        '${ApiUtils.modulesapiurl(false)}/order/cancel_order.php?id=$id'));
    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      return false;
    }
  }
}
