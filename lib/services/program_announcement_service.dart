import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/program_announcement_model.dart';
import 'package:ybb_event_app/utils/app_constants.dart';

class ProgramAnnouncementService {
  Future<List<ProgramAnnouncementModel>> getAll(String id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/program_announcements/list?program_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<ProgramAnnouncementModel> value =
            data.map((el) => ProgramAnnouncementModel.fromJson(el)).toList();

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
