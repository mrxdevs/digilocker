import 'package:digilocker/features/neom/domain/entities/meon_access_details.dart';
import 'package:digilocker/features/neom/domain/entities/meon_user_data_details.dart';
import 'package:digilocker/features/neom/domain/repositories/meon_repository.dart';

class FetchUserData {
  final MeonRepository _meonRepository;

  FetchUserData(this._meonRepository);

  Future<MeonUserDataDetails?> call(MeonAccessDetails mad) {
    return _meonRepository.fetchUserDetailsFromDigilocker(mad);
  }
}
