import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ybb_event_app/models/participant_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class ParticipantService {
  Future<List<ParticipantModel>?> getParticipantsById(String? id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/participants/participant_user?user_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        List<ParticipantModel> participants = [];

        for (var part in data) {
          participants.add(ParticipantModel.fromJson(part));
        }

        return participants;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ParticipantModel> updateData(
      String id, Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/participants/update/$id');

    try {
      var response = await http.post(
        url,
        body: data,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return ParticipantModel.fromJson(data);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
