import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/program_essay_model.dart';
import 'package:ybb_event_app/utils/app_constants.dart';

class ProgramEssayService {
  Future<List<ProgramEssayModel>> getProgramEssays(String id) async {
    var url =
        Uri.parse('${AppConstants.apiUrl}/program_essays/list?program_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<ProgramEssayModel> value =
            data.map((el) => ProgramEssayModel.fromJson(el)).toList();

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
