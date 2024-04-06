import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/program_category_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class ProgramCategoryService {
  Future<List<ProgramCategoryModel>> getProgramCategories() async {
    var url = Uri.parse('${AppConstants.apiUrl}/program_categories/');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<ProgramCategoryModel> value =
            data.map((photo) => ProgramCategoryModel.fromJson(photo)).toList();

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
