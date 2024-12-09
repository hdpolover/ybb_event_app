import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/testimony_model.dart';
import 'package:ybb_event_app/models/web_setting_about_model.dart';
import 'package:ybb_event_app/models/web_setting_home_model.dart';
import 'package:ybb_event_app/utils/app_constants.dart';

class LandingPageService {
  Future<ProgramInfoByUrlModel> getProgramInfo(String link) async {
    var url =
        Uri.parse('${AppConstants.apiUrl}/program_categories/web?url=$link');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return ProgramInfoByUrlModel.fromJson(data);
      } else {
        print(response.body);
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<WebSettingHomeModel> getHomeSetting(String id) async {
    var url =
        Uri.parse('${AppConstants.apiUrl}/web_setting_home/program_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<WebSettingHomeModel> item = [];

        for (var part in data) {
          item.add(WebSettingHomeModel.fromJson(part));
        }

        item.removeWhere((element) => element.programId != id);

        return item.first;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<WebSettingAboutModel> getAboutSetting(String id) async {
    var url =
        Uri.parse('${AppConstants.apiUrl}/web_setting_about/program_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        List<WebSettingAboutModel> item = [];

        for (var part in data) {
          item.add(WebSettingAboutModel.fromJson(part));
        }

        item.removeWhere((element) => element.programId != id);

        return item.first;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TestimonyModel>> getTestimonies(String id) async {
    var url =
        Uri.parse('${AppConstants.apiUrl}/program_testimonies/program?id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<TestimonyModel> value =
            data.map((photo) => TestimonyModel.fromJson(photo)).toList();

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
