import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/paper_detail_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class PaperDetailService {
  Future<List<PaperDetailModel>> getAll(String? programid) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/paper_details/list_program?id=$programid');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<PaperDetailModel> value =
            data.map((i) => PaperDetailModel.fromJson(i)).toList();

        return value;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaperDetailModel> getById(String? id) async {
    var url = Uri.parse('${AppConstants.apiUrl}/paper_details/$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<PaperDetailModel> value =
            data.map((i) => PaperDetailModel.fromJson(i)).toList();

        // only get same id
        PaperDetailModel paper =
            value.firstWhere((element) => element.id == id);

        return paper;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  // save
  Future<PaperDetailModel> save(Map<String, dynamic> data) {
    var url = Uri.parse('${AppConstants.apiUrl}/paper_details/save');

    print(url);

    try {
      return http.post(url, body: data).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)['data'];

          return PaperDetailModel.fromJson(data);
        } else {
          throw jsonDecode(response.body)['message'];
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  // update
  Future<PaperDetailModel> update(Map<String, dynamic> data, String id) {
    var url = Uri.parse('${AppConstants.apiUrl}/paper_details/update/$id');

    print(url);

    try {
      return http.post(url, body: data).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)['data'];

          print(data);

          return PaperDetailModel.fromJson(data);
        } else {
          throw jsonDecode(response.body)['message'];
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
