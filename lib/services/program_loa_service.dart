import 'package:ybb_event_app/models/paper_revision_model.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/program_loa_model.dart';
import 'package:ybb_event_app/utils/app_constants.dart';

class ProgramLoaService {
  Future<List<ProgramLoaModel>> getAll(String programId) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/program_loas/list?program_id=$programId');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<ProgramLoaModel> value =
            data.map((el) => ProgramLoaModel.fromJson(el)).toList();

        return value;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future generateLoa(String programId, Map<String, dynamic> data) async {
    String formattedData = "";
    // map data into string
    data.forEach((key, value) {
      formattedData += "$key=$value&";
    });

    var url = Uri.parse(
        '${AppConstants.apiUrl}/program_loas/generate?program_id=$programId&$formattedData');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>> getDetails(String participantId) {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/program_loas/get_details?participant_id=$participantId');

    print(url);

    try {
      return http.get(url).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)['data'];

          // from json to map
          Map<String, String> value = Map<String, String>.from(data);

          return value;
        } else {
          throw Exception('Failed');
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
