import 'package:digilocker/features/neom/domain/entities/meon_access_details.dart';
import 'package:digilocker/features/neom/domain/repositories/meon_repository.dart';

class GetAccessDetails {
  final MeonRepository meonRepo;

  GetAccessDetails(this.meonRepo);

  Future<MeonAccessDetails?> call() {
    return meonRepo.getAccessToken();
  }
}
