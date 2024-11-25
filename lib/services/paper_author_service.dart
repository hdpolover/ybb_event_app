import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/paper_author_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class PaperAuthorService {
  Future<PaperAuthorModel> getAll(String? id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/paper_authors/participant?participant_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<PaperAuthorModel> value =
            data.map((photo) => PaperAuthorModel.fromJson(photo)).toList();

        return value[0];
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PaperAuthorModel>> getAllByPaperDetailId(String? id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/paper_authors/list?paper_detail_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<PaperAuthorModel> value =
            data.map((photo) => PaperAuthorModel.fromJson(photo)).toList();

        return value;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaperAuthorModel> save(Map<String, dynamic> data) {
    var url = Uri.parse('${AppConstants.apiUrl}/paper_authors/save');

    print(url);

    try {
      return http.post(url, body: data).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)['data'];

          return PaperAuthorModel.fromJson(data);
        } else {
          print(jsonDecode(response.body)['message']);
          throw jsonDecode(response.body)['message'];
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  // update author
  Future<PaperAuthorModel> update(Map<String, dynamic> data, String id) {
    var url = Uri.parse('${AppConstants.apiUrl}/paper_authors/update/$id');

    try {
      return http.post(url, body: data).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)['data'];

          return PaperAuthorModel.fromJson(data);
        } else {
          throw jsonDecode(response.body)['message'];
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  // delete author
  Future<void> delete(String id) {
    var url = Uri.parse('${AppConstants.apiUrl}/paper_authors/delete?id=$id');

    print(url);

    try {
      return http.get(url).then((response) {
        if (response.statusCode == 200) {
          return;
        } else {
          throw jsonDecode(response.body)['message'];
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
