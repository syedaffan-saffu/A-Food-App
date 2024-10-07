import 'package:rajputfoods/utils/auth/apiutils.dart';

class OrderlistData {
  final String orderid;
  final String title;
  final String status;
  final String price;
  final String image;

  const OrderlistData({
    required this.title,
    required this.image,
    required this.orderid,
    required this.status,
    required this.price,
  });

  factory OrderlistData.fromJson(Map<String, dynamic> json) {
    return OrderlistData(
      orderid: json['id'],
      title: json['title'],
      image: json['image'],
      status: json['status'],
      price: json['net_price'],
    );
  }
  static List<OrderlistData> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => OrderlistData.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

class OrderItemDetails {
  final String quantity;
  final String img;
  final String price;

  const OrderItemDetails({
    required this.quantity,
    required this.img,
    required this.price,
  });

  factory OrderItemDetails.fromJson(Map<String, dynamic> json) {
    return OrderItemDetails(
      quantity: json['quantity'],
      img: "${ApiUtils.imageapiurl(false)}/${json['image']}",
      price: json['unit_price'],
    );
  }
  static List<OrderItemDetails> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => OrderItemDetails.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

class OrderStatusData {
  final String status;
  final String time;

  const OrderStatusData({required this.status, required this.time});

  factory OrderStatusData.fromJson(Map<String, dynamic> json) {
    return OrderStatusData(status: json['status'], time: json['time']);
  }
  static List<OrderStatusData> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => OrderStatusData.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
