import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ybb_event_app/models/agreement_letter_model.dart';
import 'package:ybb_event_app/models/program_document_model.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/documents/agreement_letter_upload.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class ProgramDocumentService {
  Future<List<ProgramDocumentModel>> getAll(String? id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/program_documents/participant?id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;

        List<ProgramDocumentModel> value =
            data.map((photo) => ProgramDocumentModel.fromJson(photo)).toList();

        return value;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future getInvitationLetter(String? id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/document_invitation/generate_pdf?id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future agreementLetterUpload(String id, Map<String, dynamic> data) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '${AppConstants.apiUrl}/program_documents/agreement_letter_upload'),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        data['file_bytes'],
        filename: data['file_name'],
      ),
    );
    request.headers.addAll(headers);
    request.fields.addAll({
      "participant_id": id,
    });

    try {
      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return data;
      } else {
        print(response.body);
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AgreementLetterModel> getAgreementLetter(String? id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/program_documents/agreement_letter?participant_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return AgreementLetterModel.fromJson(data);
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
