import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/competition_category_model.dart';
import 'package:ybb_event_app/models/participant_competition_category_model.dart';
import 'package:ybb_event_app/utils/app_constants.dart';

class ParticipantCompetitionCategoryService {
  Future<List<ParticipantCompetitionCategoryModel>> getAll() async {
    var url =
        Uri.parse('${AppConstants.apiUrl}/participant_competition_categories/');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<ParticipantCompetitionCategoryModel> value = data
            .map((el) => ParticipantCompetitionCategoryModel.fromJson(el))
            .toList();

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ParticipantCompetitionCategoryModel> getById(String id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/participant_competition_categories?participant_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        ParticipantCompetitionCategoryModel value =
            ParticipantCompetitionCategoryModel.fromJson(data);

        return value;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ParticipantCompetitionCategoryModel> save(
      Map<String, dynamic> data) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/participant_competition_categories/save');

    print(url);

    try {
      var response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return ParticipantCompetitionCategoryModel.fromJson(data);
      } else {
        print(response.body);
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
