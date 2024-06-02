import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/payment_method_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class PaymentMethodService {
  Future<List<PaymentMethodModel>> getAll(String? id) async {
    var url =
        Uri.parse('${AppConstants.apiUrl}/payment_methods/list?program_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<PaymentMethodModel> value =
            data.map((item) => PaymentMethodModel.fromJson(item)).toList();

        return value;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentMethodModel> getById(String? id) async {
    var url = Uri.parse('${AppConstants.apiUrl}/payment_methods?id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        PaymentMethodModel value = PaymentMethodModel.fromJson(data);

        return value;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
