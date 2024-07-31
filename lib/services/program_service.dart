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
        print(response.body);
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProgramModel>> getPrograms() async {
    var url = Uri.parse('${AppConstants.apiUrl}/programs');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        List<ProgramModel> programs = [];

        for (var i = 0; i < data.length; i++) {
          programs.add(ProgramModel.fromJson(data[i]));
        }

        return programs;
      } else {
        print(response.body);
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
