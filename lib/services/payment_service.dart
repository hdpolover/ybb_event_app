import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/payment_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class PaymentService {
  Future<bool> savePayment(Map<String, dynamic> data) async {
    ///MultiPart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.apiUrl}/payments/save'),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile.fromBytes(
        'proof_url',
        data['file_bytes'],
        filename: data['file_name'],
      ),
    );
    request.headers.addAll(headers);
    request.fields.addAll({
      "participant_id": data['participant_id'],
      "program_payment_id": data['program_payment_id'],
      "payment_method_id": data['payment_method_id'],
      "amount": data['amount'],
      "account_name": data['account_name'],
      "source_name": data['source_name'],
    });

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PaymentModel>> getAll(String? id) async {
    var url =
        Uri.parse('${AppConstants.apiUrl}/payments/list?participant_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<PaymentModel> value =
            data.map((item) => PaymentModel.fromJson(item)).toList();

        return value;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> xenditPay(Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/payments/pay');

    try {
      var response = await http.post(
        url,
        body: {
          //add these: description, payer_email, amount, participant_id, program_payment_id, payment_method_id, account_name, program_id
          "description": data['description'],
          "payer_email": data['payer_email'],
          "amount": data['amount'],
          "participant_id": data['participant_id'],
          "program_payment_id": data['program_payment_id'],
          "payment_method_id": data['payment_method_id'],
          "account_name": data['account_name'],
          "program_id": data['program_id'],
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return data;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> midtransPay(Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/payments/pay_midtrans');

    try {
      var response = await http.post(
        url,
        body: {
          //add these: description, payer_email, amount, participant_id, program_payment_id, payment_method_id, account_name, program_id
          "description": data['description'],
          "price": data['price'],
          "participant_id": data['participant_id'],
          "program_payment_id": data['program_payment_id'],
          "payment_method_id": data['payment_method_id'],
          "name": data['name'],
          "program_id": data['program_id'],
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return data;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
