import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/program_payment_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class ProgramPaymentService {
  Future<List<ProgramPaymentModel>> getAll(String? id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/program_payments/list?program_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<ProgramPaymentModel> value =
            data.map((photo) => ProgramPaymentModel.fromJson(photo)).toList();

        return value;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ProgramPaymentModel> getById(String? id) async {
    var url = Uri.parse('${AppConstants.apiUrl}/program_payments?id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        ProgramPaymentModel value = ProgramPaymentModel.fromJson(data);

        return value;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
