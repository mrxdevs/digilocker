import 'package:dio/dio.dart';

class NeomDocumentApiImp {
  static const String _baseUrl = "";
  Dio _dio = Dio();

  fetchDrivingLicences() {

    final header={
      "Content-Type": "application/json"

    };

    final data= {
      "company_name": "Raptee Energy",
    "secret_token": ne


    };
    _dio.options=BaseOptions(
      method: "get",
      baseUrl: _baseUrl,
      headers: header,
      


    )
  }
}
