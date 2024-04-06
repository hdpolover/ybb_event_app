import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/program_category_model.dart';
import 'package:ybb_event_app/models/program_schedule_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class ScheduleService {
  Future<List<ProgramScheduleModel>> getProgramSchedules() async {
    var url = Uri.parse('${AppConstants.apiUrl}/program_schedules/');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<ProgramScheduleModel> value =
            data.map((photo) => ProgramScheduleModel.fromJson(photo)).toList();

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
