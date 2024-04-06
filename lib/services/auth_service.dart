import 'dart:convert';

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

  Future<List<ParticipantModel>> participantSignIn(
      Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/participants/signin');

    print(url);
    print(data);

    try {
      var response = await http.post(
        url,
        body: {
          "email": data["email"],
          "password": data["password"],
          "program_category_id": data["program_category_id"],
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        List<ParticipantModel> participants = [];

        for (var part in data) {
          participants.add(ParticipantModel.fromJson(part));
        }

        return participants;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AmbassadorModel> ambassadorSignIn(Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/ambassadors/login');

    print(url);

    try {
      var response = await http.post(
        url,
        body: {
          "email": data["email"],
          "ref_code": data["ref_code"],
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
}
