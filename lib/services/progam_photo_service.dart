import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/program_photo_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class ProgramPhotoService {
  Future<List<ProgramPhotoModel>> getProgramPhotos(String? id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/program_photos/program_category_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<ProgramPhotoModel> photos =
            data.map((photo) => ProgramPhotoModel.fromJson(photo)).toList();

        return photos;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
