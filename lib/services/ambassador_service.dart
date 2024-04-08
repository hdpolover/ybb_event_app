import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/ambassador_model.dart';
import 'package:ybb_event_app/models/participant_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class AmbassadorService {
  Future<List<ParticipantModel>> getParticipants(String? ref_code) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/participants/list_ambassador?ref_code=$ref_code');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<ParticipantModel> value =
            data.map((photo) => ParticipantModel.fromJson(photo)).toList();

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AmbassadorModel> validateCode(String refCode) async {
    var url =
        Uri.parse('${AppConstants.apiUrl}/participants/validate_ref_code');

    print(url);

    try {
      var response = await http.post(url, body: {
        'ref_code': refCode,
      });

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
