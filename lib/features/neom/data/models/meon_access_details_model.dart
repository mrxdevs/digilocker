import 'package:digilocker/features/neom/domain/entities/meon_access_details.dart';

class MeonAccessDetailsModel extends MeonAccessDetails {
  const MeonAccessDetailsModel({
    required super.accessToken,
    required super.state,
  });

  //Convert from map to Object
  factory MeonAccessDetailsModel.fromJson(Map data) {
    return MeonAccessDetailsModel(
      accessToken: data["client_token"] ?? "",
      state: data["state"] ?? "",
    );
  }

  // convert to map
  Map<String, dynamic> toMap(MeonAccessDetailsModel meon) {
    return {"client_token": meon.accessToken, "state": meon.state};
  }

  //To string method
  @override
  String toString() {
    return {"client_token": accessToken, "state": state}.toString();
  }
}
