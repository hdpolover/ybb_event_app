import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/ambassador_model.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/models/user_model.dart';
import 'package:ybb_event_app/utils/app_constants.dart';

class AuthService {
  Future<UserModel?> participantSignUp(UserModel userModel) async {
    var url = Uri.parse('${AppConstants.apiUrl}/users/save');

    try {
      var response = await http.post(
        url,
        body: userModel.toJson(),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return UserModel.fromJson(data);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> sendVerifEmail(String userId) async {
    var url = Uri.parse('${AppConstants.apiUrl}/users/email_verif');

    // debugPrint(url as String?);

    try {
      var response = await http.post(
        url,
        body: {
          "id": userId,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['message'];
        return data;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ParticipantModel> participantSignIn(Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/participants/signin');

    print(url);

    // debugPrint(url as String?);

    try {
      var jsonBody = json.encode({
        "email": data["email"],
        "password": data["password"],
        "program_category_id": data["program_category_id"],
      });

      var response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonBody,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      print('POST response status: ${response.statusCode}');
      print('POST response headers: ${response.headers}');
      print('POST response body: ${response.body}');

      if (response.statusCode == 200) {
        return ParticipantModel.fromJson(jsonDecode(response.body)['data']);
      } else {
        throw Exception('Failed to sign in: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AmbassadorModel> ambassadorSignIn(Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/ambassadors/login');

    // debugPrint(url as String?);

    try {
      var response = await http.post(
        url,
        body: {
          "email": data["email"],
          "ref_code": data["ref_code"].toString().toUpperCase(),
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return AmbassadorModel.fromJson(data);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> resetPassword(String id) async {
    var url = Uri.parse('${AppConstants.apiUrl}/users/email_reset_password');

    // debugPrint(url as String?);

    try {
      var response = await http.post(
        url,
        body: {
          "id": id,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['message'];

        return data;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> checkEmail(String email) async {
    var url =
        Uri.parse('${AppConstants.apiUrl}/users/check_email?email=$email');

    // debugPrint(url as String?);

    try {
      var response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return UserModel.fromJson(data);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
