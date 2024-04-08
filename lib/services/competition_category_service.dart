import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/competition_category_model.dart';
import 'package:ybb_event_app/utils/app_constants.dart';

class CompetitionCategoryService {
  Future<List<CompetitionCategoryModel>> getCompetitionCategories(
      String id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/competition_categories/list?program_category_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<CompetitionCategoryModel> value =
            data.map((el) => CompetitionCategoryModel.fromJson(el)).toList();

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> save(Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/competition_categories/save');

    print(url);

    try {
      var response = await http.post(url, body: data);

      if (response.statusCode != 200) {
        throw Exception('Failed');
      }

      return Future.value(true);
    } catch (e) {
      rethrow;
    }
  }
}
