import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ybb_event_app/models/participant_model.dart';

import 'package:ybb_event_app/utils/app_constants.dart';

class ParticipantService {
  Future<List<ParticipantModel>?> getParticipantsById(String? id) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/participants/participant_user?user_id=$id');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        List<ParticipantModel> participants = [];

        for (var part in data) {
          participants.add(ParticipantModel.fromJson(part));
        }

        return participants;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ParticipantModel> updateData(
      String id, Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/participants/update/$id');

    try {
      var response = await http.post(
        url,
        body: data,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return ParticipantModel.fromJson(data);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ParticipantModel> updateBasicInformationDataWithoutPhoto(
      String id, Map<String, dynamic> data) async {
    var url = Uri.parse('${AppConstants.apiUrl}/participants/update/$id');

    try {
      var response = await http.post(
        url,
        body: data,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return ParticipantModel.fromJson(data);
      } else {
        print(response.body);
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print("here" + e.toString());
      rethrow;
    }
  }

  Future<ParticipantModel> updateAchievementDataWithCv(
      String id, Map<String, dynamic> data) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.apiUrl}/participants/update/$id'),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile.fromBytes(
        'resume_url',
        data['file_bytes'],
        filename: data['file_name'],
      ),
    );
    request.headers.addAll(headers);
    request.fields.addAll({
      "achievements": data['achievements'],
      "experiences": data['experiences'],
    });

    try {
      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return ParticipantModel.fromJson(data);
      } else {
        print(response.body);
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ParticipantModel> updateBasicInformationDataWithPhoto(
      String id, Map<String, dynamic> data) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.apiUrl}/participants/update/$id'),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile.fromBytes(
        'picture_url',
        data['file_bytes'],
        filename: data['file_name'],
      ),
    );
    request.headers.addAll(headers);
    request.fields.addAll({
      "full_name": data['full_name'],
      "birthdate": data['birthdate'],
      "gender": data['gender'],
      "country_code": data['country_code'],
      "phone_number": data['phone_number'],
      "emergency_account": data['emergency_account'],
      "origin_address": data['origin_address'],
      "current_address": data['current_address'],
      "nationality": data['nationality'],
      "occupation": data['occupation'],
      "institution": data['institution'],
      "organizations": data['organizations'],
      "disease_history": data['disease_history'],
      "tshirt_size": data['tshirt_size'],
      "contact_relation": data['contact_relation'],
      "instagram_account": data['instagram_account'],
    });

    try {
      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        return ParticipantModel.fromJson(data);
      } else {
        print(response.body);
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ParticipantModel>> getReferredParticipants(String refCode) {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/participants/list_ambassador?ref_code=$refCode');

    print(url);

    return http.get(url).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        List<ParticipantModel> participants = [];

        for (var part in data) {
          participants.add(ParticipantModel.fromJson(part));
        }

        return participants;
      } else {
        throw Exception('Failed');
      }
    });
  }

  Future<ParticipantModel?> checkParticipantByEmailAndProgramId(
      String? email, String? programId) async {
    var url = Uri.parse(
        '${AppConstants.apiUrl}/participants/check?email=$email&program_id=$programId');

    print(url);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        List<ParticipantModel> participants = [];

        for (var part in data) {
          participants.add(ParticipantModel.fromJson(part));
        }

        return participants.isNotEmpty ? participants[0] : null;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
