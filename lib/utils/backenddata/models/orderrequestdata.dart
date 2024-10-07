import 'package:rajputfoods/utils/auth/apiutils.dart';

class OrderRequest {
  final List<Map<String, dynamic>> items;
  final String totalPrice;
  final String customerId;
  final String totalitems;
  final String netPrice;
  final String? latitude;
  final String? longitude;
  final String? location;
  final String? phone;
  final String? locationtitle;

  OrderRequest({
    required this.netPrice,
    required this.items,
    required this.totalPrice,
    required this.customerId,
    required this.totalitems,
    this.latitude,
    this.longitude,
    this.location,
    this.phone,
    this.locationtitle,
  });

  // Convert the OrderRequest instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'net_price': netPrice,
      'total_items': totalitems,
      'items': items,
      'total_price': totalPrice,
      'customer_id': Encodedata.decodeid(customerId),
      'address': location,
      'lat': latitude,
      'longs': longitude,
      'phone': phone,
      'address_title': locationtitle
    };
  }

  // Convert a JSON map to an OrderRequest instance
  // factory OrderRequest.fromJson(Map<String, dynamic> json) {
  //   return OrderRequest(
  //     netPrice: json['net_price'],
  //     totalitems: json['total_items'],
  //     items: List<Map<String, dynamic>>.from(json['items']),
  //     totalPrice: json['total_price'],
  //     customerId: json['customer_id'],
  //   );
  // }
}

class OrderReview {
  final String salesid;
  final String customerId;
  final String rating;
  final String comment;

  OrderReview({
    required this.comment,
    required this.salesid,
    required this.customerId,
    required this.rating,
  });

  // Convert the OrderRequest instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'review': rating,
      'sale_id': salesid,
      'customer_id': Encodedata.decodeid(customerId),
    };
  }
}
