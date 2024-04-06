import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/faq_model.dart';
import 'package:ybb_event_app/utils/app_constants.dart';

class FaqService {
  Future<List<FaqModel>> getProgramFaqs(String? id) async {
    var url = Uri.parse('${AppConstants.apiUrl}/program_faqs/');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<FaqModel> value =
            data.map((photo) => FaqModel.fromJson(photo)).toList();

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
