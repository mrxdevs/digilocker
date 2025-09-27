import 'package:digilocker/features/neom/domain/repositories/meon_repository.dart';

class GetLicenseDigilockerUrl {
  final MeonRepository _meonRepository;

  GetLicenseDigilockerUrl(this._meonRepository);

  Future<String?> call(String dlno, String clienToken, String orgId) async {
    return _meonRepository.getLicenseDigilockerUrl(dlno, clienToken, orgId);
  }
}
