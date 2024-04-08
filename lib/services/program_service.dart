import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/program_model.dart';
import 'package:ybb_event_app/utils/app_constants.dart';

class ProgramService {
  Future<ProgramModel> getProgramById(String id) async {
    var url = Uri.parse('${AppConstants.apiUrl}/programs?id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return ProgramModel.fromJson(data);
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
