import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/paper_abstract_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class PaperAbstractService {
  Future<PaperAbstractModel?> getById(String? id) async {
    var url = Uri.parse('${AppConstants.apiUrl}/paper_abstracts?id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        PaperAbstractModel paper = PaperAbstractModel.fromJson(data);

        return paper;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  // save
  Future<PaperAbstractModel> save(Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/paper_abstracts/save');

    print(url);

    try {
      var response = await http.post(url, body: data);

      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        PaperAbstractModel paper = PaperAbstractModel.fromJson(data);

        return paper;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaperAbstractModel> update(
      Map<String, dynamic> data, String id) async {
    var url = Uri.parse('${AppConstants.apiUrl}/paper_abstracts/update/$id');

    print(url);

    try {
      var response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        PaperAbstractModel paper = PaperAbstractModel.fromJson(data);

        return paper;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
