import 'package:rajputfoods/utils/auth/apiutils.dart';

class ProfileData {
  final String username;
  final String? profileimg;
  final String email;
  final String? phone;
  final String? addresstitle;
  final String? address;

  ProfileData({
    this.address,
    this.addresstitle,
    required this.username,
    this.profileimg,
    required this.email,
    this.phone,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      addresstitle: json['address_title'] ?? "",
      address: json['address'] ?? "*Add Address*",
      phone: json['phone'] ?? "*Add Phone*",
      username: json['username'],
      profileimg:
          "${ApiUtils.uploadsapiurl2(false)}/upload/${json['user_profile'] ?? "addphoto.jpg"}",
      email: json['email'],
    );
  }
}
