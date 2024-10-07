// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/utils/utilspack2.dart';

String getid(String data) {
  Map<String, dynamic> json = jsonDecode(data);
  String userid = json['id'].toString();
  print("got user id ater sign in ::::::: $userid");
  return userid;
}

String getuserid(String data) {
  Map<String, dynamic> json = jsonDecode(data);
  String userid = json['user_id'].toString();
  return userid;
}

class AuthLogin {
  static Future<void> auth(
    String email,
    String pass,
    Function(bool) onValidationResult,
    Function(String) id,
    BuildContext context,
  ) async {
    if (_ValidateLoginFields.arefieldsValid(email, pass)) {
      final Map creds = {"email": email, "password": pass};
      final response = await http.post(
          Uri.parse("${ApiUtils.modulesapiurl(false)}/login/login.php"),
          body: creds);

      if (response.statusCode == 200) {
        onValidationResult(true);
        id(getid(response.body));
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
            UtilsPack2.snackBar("Email or Password is Incorrect", 1));
      } else if (response.statusCode == 403) {
        ScaffoldMessenger.of(context)
            .showSnackBar(UtilsPack2.snackBar("User not verified", 1));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(UtilsPack2.snackBar("Unable to Login", 1));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          UtilsPack2.snackBar("Not All Fields are Filled or Valid", 1));
    }
  }
}

abstract class _ValidateLoginFields {
  static bool arefieldsValid(String email, String pass) {
    final bool valid;
    if (email.isEmpty || pass.isEmpty) {
      valid = false;
    } else {
      valid = true;
    }
    return valid;
  }
}

abstract class _ValidateSignupFields {
  static bool arefieldsValid(String name, String email, String pass) {
    final bool valid;
    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      valid = false;
    } else if (!ValidationUtils.isEmailValid(email)) {
      valid = false;
    } else {
      valid = true;
    }
    return valid;
  }
}

abstract class _ValidatePassFields {
  static bool arefieldsValid(
      String pass, String cnfrmpass, BuildContext context) {
    final bool valid;
    if (pass.isEmpty || cnfrmpass.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Field is Empty", 1));
      valid = false;
    } else if (!ValidationUtils.isCnfPassValid(pass, cnfrmpass)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Confirm Password is not Same", 1));
      valid = false;
    } else {
      valid = true;
    }
    return valid;
  }
}

class AuthSignup {
  static Future<void> socialauth(
    String name,
    String email,
    Function(bool) onValidationResult,
    Function(String) id,
    BuildContext context,
  ) async {
    final Map creds = {
      "username": name,
      "email": email,
    };
    final response = await http.post(
        Uri.parse("${ApiUtils.modulesapiurl(false)}/login/google_sign.php"),
        body: creds);
    if (response.statusCode == 200) {
      onValidationResult(true);
      print("id :::::::::: ${id(getuserid(response.body))}");
      id(getuserid(response.body));
    } else if (response.statusCode == 406) {
      ScaffoldMessenger.of(context).showSnackBar(
          UtilsPack2.snackBar("User with same Email already exist", 2));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Unable to Sign Up", 1));
    }
  }

  static Future<void> auth(String name, String email, String pass,
      Function(bool) onValidationResult, BuildContext context) async {
    if (_ValidateSignupFields.arefieldsValid(name, email, pass)) {
      final Map creds = {"username": name, "email": email, "password": pass};
      print(creds);
      final response = await http.post(
          Uri.parse("${ApiUtils.modulesapiurl(false)}/register/register.php"),
          body: creds);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        onValidationResult(true);
      } else if (response.statusCode == 406) {
        ScaffoldMessenger.of(context).showSnackBar(
            UtilsPack2.snackBar("User with same Email already exist", 2));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(UtilsPack2.snackBar("Unable to Sign Up", 1));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          UtilsPack2.snackBar("Not All Fields are Filled or Valid", 1));
    }
  }
}

class ValidateOTP {
  static Future<void> validate(
    String email,
    String otp,
    Function(bool) onValidationResult,
    BuildContext context,
  ) async {
    final Map creds = {"email": email, "otp": otp};

    final response = await http.post(
        Uri.parse("${ApiUtils.apiurl(false)}/include/user_verify.php"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(creds));
    if (response.statusCode == 200) {
      onValidationResult(true);
      print(response.body);
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("OTP is Invalid or Expired", 2));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Unable to Verify", 1));
    }
  }
  // static Future<void> validate(
  //   String email,
  //   String otp,
  //   Function(bool) onValidationResult,
  //   BuildContext context,
  //   Function(String) id,
  // ) async {
  //   final Map creds = {"email": email, "otp": otp};

  //   // Logging request
  //   print("Request Body: ${json.encode(creds)}");

  //   final response = await http.post(
  //       Uri.parse("${ApiUtils.apiurl(false)}/include/user_verify.php"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Accept-Encoding': 'gzip',
  //       },
  //       body: json.encode(creds));

  //   // Logging response details
  //   print("Response Status Code: ${response.statusCode}");
  //   print("Response Headers: ${response.headers}");
  //   print("Response Body: ${response.body}");

  //   if (response.statusCode == 200) {
  //     onValidationResult(true);

  //     // Logging parsed JSON
  //     Map<String, dynamic> jsonResponse = jsonDecode(response.body);
  //     print("Parsed JSON: $jsonResponse");

  //     if (jsonResponse.containsKey('user_id')) {
  //       id(jsonResponse['user_id'].toString());
  //     } else {
  //       print("Error: 'user_id' key not found in response");
  //     }
  //   } else if (response.statusCode == 401) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(UtilsPack2.snackBar("OTP is Invalid or Expired", 2));
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(UtilsPack2.snackBar("Unable to Verify", 1));
  //   }
  // }

  // static String getuserid(String responseBody) {
  //   // Example implementation to extract user_id
  //   final Map<String, dynamic> json = jsonDecode(responseBody);
  //   return json['user_id']?.toString() ?? '';
  // }
}

class ValidateForgetPassOTP {
  static Future<void> validate(String email, String otp,
      Function(bool) onValidationResult, BuildContext context) async {
    final Map creds = {"email": email, "otp": otp};

    final response = await http.post(
        Uri.parse("${ApiUtils.apiurl(false)}/include/user_verify.php"),
        body: json.encode(creds));

    if (response.statusCode == 200) {
      onValidationResult(true);
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("OTP is Invalid or Expired", 2));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Unable to Verify", 1));
    }
  }
}

class ForgetPass {
  static Future<void> authenticate(String email,
      Function(bool) onValidationResult, BuildContext context) async {
    final Map creds = {"email": email};

    if (ValidationUtils.isEmailValid(email)) {
      final response = await http.post(
          Uri.parse("${ApiUtils.modulesapiurl(false)}/forget/forget.php"),
          body: jsonEncode(creds));

      if (response.statusCode == 200) {
        onValidationResult(true);
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context)
            .showSnackBar(UtilsPack2.snackBar("Email not Found", 2));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(UtilsPack2.snackBar("Unable to Send Otp", 1));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Not a Valid Email Format", 1));
    }
  }
}

class ResetPass {
  static Future<void> reset(String email, String pass, String cnfrmpass,
      Function(bool) onValidationResult, BuildContext context) async {
    if (_ValidatePassFields.arefieldsValid(pass, cnfrmpass, context)) {
      final Map creds = {"email": email, "new_password": cnfrmpass};
      final response = await http.post(
          Uri.parse("${ApiUtils.modulesapiurl(false)}/forget/reset.php"),
          body: jsonEncode(creds));
      if (response.statusCode == 200) {
        onValidationResult(true);
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context)
            .showSnackBar(UtilsPack2.snackBar("Email not Found", 2));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            UtilsPack2.snackBar("Unable to perform vaidation", 1));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          UtilsPack2.snackBar("Check validation of both fiels", 1));
    }
  }
}
