import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/paper_topic_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class PaperTopicService {
  Future<List<PaperTopicModel>?> getAll(String? programId) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/paper_topics/list?program_id=$programId');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        List<PaperTopicModel> topics = [];

        for (var topic in data) {
          topics.add(PaperTopicModel.fromJson(topic));
        }

        return topics;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}
