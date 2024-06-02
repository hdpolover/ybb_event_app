import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/participant_status_model.dart';
import 'package:ybb_event_app/models/program_payment_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class ParticipantStatusService {
  Future<List<ParticipantStatusModel>> getAll(String? id) async {
    var url = Uri.parse('${AppConstants.apiUrl}/participant_statuses');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<ParticipantStatusModel> value =
            data.map((item) => ParticipantStatusModel.fromJson(item)).toList();

        return value;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ParticipantStatusModel> getByParticipantId(String? id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/participant_statuses/list?participant_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'][0];

        ParticipantStatusModel value = ParticipantStatusModel.fromJson(data);

        return value;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ParticipantStatusModel> updateStatus(
      String id, Map<String, dynamic> data) async {
    var url =
        Uri.parse('${AppConstants.apiUrl}/participant_statuses/update/$id');

    print(url);

    try {
      var response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return ParticipantStatusModel.fromJson(data);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
