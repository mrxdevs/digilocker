import 'dart:convert';

import 'package:digilocker/core/secerate/.env.dart';
import 'package:digilocker/features/neom/data/models/meon_access_details_model.dart';
import 'package:digilocker/features/neom/data/models/meon_user_data_details_model.dart';
import 'package:digilocker/features/neom/domain/entities/meon_access_details.dart';
import 'package:digilocker/features/neom/domain/entities/meon_user_data_details.dart';
import 'package:dio/dio.dart';
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

    try {
      final response = await dio.post(
        "v2/send_entire_data",
        data: data,
        options: Options(headers: header),
      );

      if (response.statusCode == 200) {
        final data = await jsonDecode(response.data);
        return MeonUserDataDetailsModel.fromJson(data["data"]);
      } else {
        throw Exception(response);
      }
    } catch (e, s) {
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

    try {
      final response = await dio.post(
        "/get_access_token",
        data: data,
        options: Options(headers: header),
      );

      if (response.statusCode == 200) {
        final data = await jsonDecode(response.data);
        return MeonAccessDetailsModel.fromJson(data);
      } else {
        throw Exception(response);
      }
    } catch (e, s) {
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

    try {
      final response = await dio.post(
        "/digi_url",
        data: data,
        options: Options(headers: header),
      );

      if (response.statusCode == 200) {
        final data = await jsonDecode(response.data);
        return data;
      } else {
        throw Exception(response);
      }
    } catch (e, s) {
      throw Exception(s.toString());
    }
  }

  @override
  Future openUrlonWeb(String url) async {
    return await launchUrl(Uri.parse(url));
  }
}
