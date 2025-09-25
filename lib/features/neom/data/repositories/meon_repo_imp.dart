import 'package:digilocker/features/neom/data/datasources/meon_remote_datasource.dart';
import 'package:digilocker/features/neom/domain/entities/meon_access_details.dart';
import 'package:digilocker/features/neom/domain/entities/meon_user_data_details.dart';
import 'package:digilocker/features/neom/domain/repositories/meon_repository.dart';

class MeonRepoImp extends MeonRepository {
  final MeonRemoteDatasource _datasource;

  MeonRepoImp(this._datasource);
  @override
  Future<MeonUserDataDetails?> fetchUserDetailsFromDigilocker(
    MeonAccessDetails mad,
  ) {
    return _datasource.fetchUserDetailsFromDigilocker(mad);
  }

  @override
  Future<MeonAccessDetails?> getAccessToken() {
    return _datasource.getAccessToken();
  }

  @override
  Future<String?> getDigiLockerUrl(
    String panName,
    String panNo,
    String clientToken,
  ) {
    return _datasource.getDigiLockerUrl(panName, panNo, clientToken);
  }

  @override
  Future openUrlonWeb(String url) {
    return _datasource.openUrlonWeb(url);
  }
}
