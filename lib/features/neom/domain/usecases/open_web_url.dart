import 'package:digilocker/features/neom/domain/repositories/meon_repository.dart';

class OpenWebUrl {
  final MeonRepository _meonRepository;

  OpenWebUrl(this._meonRepository);

  Future<dynamic> call(String url) {
    return _meonRepository.openUrlonWeb(url);
  }
}
