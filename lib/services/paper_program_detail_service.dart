import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/competition_category_model.dart';
import 'package:ybb_event_app/models/paper_program_detail_model.dart';
import 'package:ybb_event_app/models/participant_competition_category_model.dart';
import 'package:ybb_event_app/models/participant_essay_model.dart';
import 'package:ybb_event_app/utils/app_constants.dart';

class PaperProgramDetailService {
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

  Future<PaperProgramDetailModel> getById(String id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/paper_program_details/list?program_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<PaperProgramDetailModel> value =
            data.map((el) => PaperProgramDetailModel.fromJson(el)).toList();

        // only return the element with program_id = id
        return value.firstWhere((element) => element.programId == id);
      } else {
        return PaperProgramDetailModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ParticipantEssayModel> save(Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/participant_essays/save');

    print(url);

    try {
      var response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return ParticipantEssayModel.fromJson(data);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
