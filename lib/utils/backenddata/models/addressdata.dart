import 'package:rajputfoods/utils/auth/apiutils.dart';

class UserAddresses {
  final String addressid;
  final String useraddress;
  final String title;
  UserAddresses(
      {required this.useraddress,
      required this.title,
      required this.addressid});
  factory UserAddresses.fromjson(Map<String, dynamic> json) {
    return UserAddresses(
        useraddress: json['address'],
        title: json['title'],
        addressid: json['id']);
  }
  static List<UserAddresses> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => UserAddresses.fromjson(json as Map<String, dynamic>))
        .toList();
  }
}

class AddressRequest {
  final String userid;
  final String address;
  final String title;
  AddressRequest(
      {required this.address, required this.title, required this.userid});
  Map<String, dynamic> toJson() {
    return {
      "user_id": Encodedata.decodeid(userid),
      "address": address,
      "title": title,
    };
  }
}
