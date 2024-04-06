import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
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
        var data = jsonDecode(response.body)['data'][0];

        return WebSettingHomeModel.fromJson(data);
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
        var data = jsonDecode(response.body)['data'][0];

        return WebSettingAboutModel.fromJson(data);
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
