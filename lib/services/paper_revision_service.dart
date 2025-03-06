import 'package:ybb_event_app/models/paper_revision_model.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ybb_event_app/utils/app_constants.dart';

class PaperRevisionService {
  Future<List<PaperRevisionModel>> getRevisions(String paperDetailId) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/paper_revisions/list?paper_detail_id=$paperDetailId');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<PaperRevisionModel> value =
            data.map((el) => PaperRevisionModel.fromJson(el)).toList();

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
