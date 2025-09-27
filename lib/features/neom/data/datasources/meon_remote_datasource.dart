import 'package:digilocker/core/secerate/.env.dart';
import 'package:digilocker/features/neom/data/models/meon_access_details_model.dart';
import 'package:digilocker/features/neom/data/models/meon_user_data_details_model.dart';
import 'package:digilocker/features/neom/domain/entities/meon_access_details.dart';
import 'package:digilocker/features/neom/domain/entities/meon_user_data_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class MeonRemoteDatasource {
  //To create a access token
  Future<MeonAccessDetails?> getAccessToken();

  //To get back a digilocker URL
  Future<String?> getDigiLockerUrl(
    String panName,
    String panNo,
    String clientToken,
  );

  //To open a webview
  Future openUrlonWeb(String url);

  //To getback all the details
  Future<MeonUserDataDetails?> fetchUserDetailsFromDigilocker(
    MeonAccessDetails mad,
  );

  Future<String?> getLicenseDigilockerUrl(
    String dlno,
    String clienToken,
    String orgId,
  );
}

class MeonRemoteDatasourceImp extends MeonRemoteDatasource {
  final Dio dio;

  MeonRemoteDatasourceImp(this.dio);

  @override
  Future<MeonUserDataDetails?> fetchUserDetailsFromDigilocker(
    MeonAccessDetails mad,
  ) async {
    final header = {"Content-Type": "application/json"};
    final data = {
      "client_token": mad.accessToken,
      "state": mad.state,
      "status": true,
    };
    debugPrint("***-------------[Fetch User details API]------------***");

    debugPrint('Requesting user details with data: $data and headers: $header');

    try {
      final response = await dio.post(
        "/v2/send_entire_data",
        data: data,
        options: Options(headers: header),
      );

      debugPrint(
        'Received response: ${response.statusCode} - ${response.data}',
      );

      if (response.statusCode == 200) {
        final decodedData = response.data;
        debugPrint('Decoded response data: $decodedData');
        return MeonUserDataDetailsModel.fromJson(decodedData["data"]);
      } else {
        debugPrint('Error response: $response');
        throw Exception(response);
      }
    } catch (e, s) {
      debugPrint('Exception occurred: $e\nStack trace: $s');
      throw Exception(s.toString());
    }
  }

  @override
  Future<MeonAccessDetails?> getAccessToken() async {
    final header = {"Content-Type": "application/json"};
    final data = {
      "company_name": meonCompanyName,
      "secret_token": meonSecerate,
    };

    debugPrint('Requesting access token with data: $data and headers: $header');

    try {
      final response = await dio.post(
        "/get_access_token",
        data: data,
        options: Options(headers: header),
      );

      debugPrint(
        'Received response: ${response.statusCode} - ${response.data}',
      );

      if (response.statusCode == 200) {
        debugPrint('Decoded response data: ${response.data}');
        return MeonAccessDetailsModel.fromJson(response.data);
      } else {
        debugPrint('Error response: $response');
        throw Exception(response);
      }
    } catch (e, s) {
      debugPrint('Exception occurred: $e\nStack trace: $s');
      throw Exception(s.toString());
    }
  }

  @override
  Future<String?> getDigiLockerUrl(
    String panName,
    String panNo,
    String clientToken,
  ) async {
    final header = {"Content-Type": "application/json"};
    final data = {
      "client_token": clientToken,
      "redirect_url": "https://live.meon.co.in/",
      "company_name": meonCompanyName,
      "documents": "aadhaar,pan",
      "pan_name": panName,
      "pan_no": panNo,
    };

    debugPrint(
      'Requesting DigiLocker URL with data: $data and headers: $header',
    );

    try {
      final response = await dio.post(
        "/digi_url",
        data: data,
        options: Options(headers: header),
      );

      debugPrint(
        'Received response: ${response.statusCode} - ${response.data}',
      );

      if (response.statusCode == 200) {
        debugPrint('DigiLocker URL response data: ${response.data}');
        return response.data["url"];
      } else {
        debugPrint('Error response: $response');
        throw Exception(response);
      }
    } catch (e, s) {
      debugPrint('Exception occurred: $e\nStack trace: $s');
      throw Exception(s.toString());
    }
  }

  @override
  Future openUrlonWeb(String url) async {
    debugPrint('Launching URL: $url');
    return await launchUrl(Uri.parse(url));
  }

  @override
  Future<String?> getLicenseDigilockerUrl(
    String dlno,
    String clienToken,
    String orgId,
  ) async {
    final header = {"Content-Type": "application/json"};
    final data = {
      "client_token": clienToken,
      "redirect_url": "meon.co.in",
      "company_name": meonCompanyName,
      "documents": "aadhaar,pan",
      "other_documents": [
        {"doctype": "DRVLC", "orgid": orgId, "consent": "Y", "dlno": dlno},
      ],
    };

    debugPrint(
      'Requesting DigiLocker URL with data: $data and headers: $header',
    );

    try {
      final response = await dio.post(
        "/digi_url",
        data: data,
        options: Options(headers: header),
      );

      debugPrint(
        'Received response: ${response.statusCode} - ${response.data}',
      );

      if (response.statusCode == 200) {
        debugPrint('DigiLocker URL response data: ${response.data}');
        return response.data["url"];
      } else {
        debugPrint('Error response: $response');
        throw Exception(response);
      }
    } catch (e, s) {
      debugPrint('Exception occurred: $e\nStack trace: $s');
      throw Exception(s.toString());
    }
  }
}
