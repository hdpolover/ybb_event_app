import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/participant_competition_category_model.dart';
import 'package:ybb_event_app/models/participant_essay_model.dart';
import 'package:ybb_event_app/models/participant_subtheme_model.dart';
import 'package:ybb_event_app/utils/app_constants.dart';

class ParticipantSubthemeService {
  Future<List<ParticipantEssayModel>> getAll() async {
    var url = Uri.parse('${AppConstants.apiUrl}/participant_essays/');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<ParticipantEssayModel> value =
            data.map((el) => ParticipantEssayModel.fromJson(el)).toList();

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ParticipantSubthemeModel> getById(String id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/participant_subthemes?participant_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        ParticipantSubthemeModel value =
            ParticipantSubthemeModel.fromJson(data);

        return value;
      } else {
        return ParticipantSubthemeModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ParticipantSubthemeModel> save(Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/participant_subthemes/save');

    print(url);

    try {
      var response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        ParticipantSubthemeModel value =
            ParticipantSubthemeModel.fromJson(data);

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
