import 'package:digilocker/features/neom/domain/repositories/meon_repository.dart';

class GetDigilockerUrl {
  final MeonRepository _meonRepository;

  GetDigilockerUrl(this._meonRepository);

  Future<String?> call(String panName, String panNo, String clientToken) {
    return _meonRepository.getDigiLockerUrl(panName, panNo, clientToken);
  }
}
