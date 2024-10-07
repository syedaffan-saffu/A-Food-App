import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/backenddata/models/addressdata.dart';
import 'package:rajputfoods/utils/backenddata/models/profiledata.dart';

class Profileapis {
  static Future<FetchResult> fetchuserprofile(
    String id,
  ) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiUtils.modulesapiurl(false)}/index/get_user.php?id=$id'));

      if (response.statusCode == 200) {
        Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;

        return FetchResult(data: ProfileData.fromJson(json), success: true);
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      print("exception $e");
      return FetchResult(data: null, success: false);
    }
  }

  static Future<void> updateprofileinfo(
      String id, String body, void Function(bool) updated) async {
    final response = await http.post(
        Uri.parse(
            '${ApiUtils.modulesapiurl(false)}/admin/Profile/update.php?id=$id'),
        body: body);
    print("response from :: update profile ${response.body}");

    if (response.statusCode == 200) {
      updated(true);
    } else {
      throw Exception('Failed to update info');
    }
  }

  static Future<void> updateProfileImage(
      String id, String imgFilePath, void Function(bool) updated) async {
    var uri = Uri.parse(
        '${ApiUtils.modulesapiurl(false)}/admin/Profile/update.php?id=$id');
    var request = http.MultipartRequest('POST', uri);

    // Add image file
    request.files
        .add(await http.MultipartFile.fromPath('user_profile', imgFilePath));

    // Send request
    final response = await request.send();

    // Handle response
    if (response.statusCode == 200) {
      updated(true);
    } else {
      updated(false);
      throw Exception('Failed to upload image');
    }
  }

  static Future<FetchResultaddress> fetchuseraddresses(
    String id,
  ) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiUtils.modulesapiurl(false)}/index/get_address.php?id=$id'));

      if (response.statusCode == 200 || response.statusCode == 400) {
        print("response from fetching${response.body}");
        List<dynamic> json = jsonDecode(response.body) as List<dynamic>;

        return FetchResultaddress(
            data: UserAddresses.fromJsonList(json), success: true);
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      print("exception $e");
      return FetchResultaddress(data: null, success: false);
    }
  }

  static Future<void> sendAddressRequest(AddressRequest addressRequest,
      void Function(bool) issuccess, void Function(bool) haserror) async {
    final url =
        Uri.parse('${ApiUtils.modulesapiurl(false)}/index/users_address.php');

    final body = jsonEncode(addressRequest.toJson());

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

        issuccess(true);
      } else {
        print('Request failed with status: ${response.statusCode}');
        haserror(true);
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

  static Future<void> deleteAddress(
      String id, void Function(bool) deleted) async {
    print(":::::::::: $id");
    final response = await http.post(
      Uri.parse(
          '${ApiUtils.modulesapiurl(false)}/index/delete_address.php?id=$id'),
    );

    if (response.statusCode == 200) {
      deleted(true);
    } else {
      throw Exception('Failed to delete address');
    }
  }
}

class FetchResultaddress {
  final List<UserAddresses>? data;
  final bool success;

  FetchResultaddress({this.data, required this.success});
}

class FetchResult {
  final ProfileData? data;
  final bool success;

  FetchResult({this.data, required this.success});
}
