import 'package:digilocker/features/neom/domain/entities/meon_access_details.dart';
import 'package:digilocker/features/neom/domain/entities/meon_user_data_details.dart';

abstract class MeonRepository {
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
