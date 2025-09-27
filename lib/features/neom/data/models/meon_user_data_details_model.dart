import 'package:digilocker/features/neom/domain/entities/meon_user_data_details.dart';

class MeonUserDataDetailsModel extends MeonUserDataDetails {
  MeonUserDataDetailsModel({
    required super.aadharAddress,
    required super.adharFileName,
    required super.aadharImageFileName,
    required super.aadharImge,
    required super.date,
    required super.fatherName,
    required super.dob,
    required super.district,
    required super.gender,
    required super.house,
    required super.locality,
    required super.name,
    required super.nameOnPan,
    required super.panImagePath,
    required super.panNo,
    required super.state,
    required super.pincode,
    required super.aadharNo,
    required super.dlFile,
  });

  //Create factory and toMap contructor
  factory MeonUserDataDetailsModel.fromJson(Map data) {
    return MeonUserDataDetailsModel(
      aadharAddress: data["aadhar_address"] ?? '',
      adharFileName: data["aadhar_filename"] ?? '',
      aadharImageFileName: data["aadhar_img_filename"] ?? '',
      aadharImge: data["adharimg"] ?? '',
      date: data["date_time"] ?? '',
      fatherName: data["fathername"] ?? '',
      dob: data["dob"] ?? '',
      district: data["dist"] ?? '',
      gender: data["gender"] ?? '',
      house: data["house"] ?? '',
      locality: data["locality"] ?? '',
      name: data["name"] ?? '',
      nameOnPan: data["name_on_pan"] ?? '',
      panImagePath: data["pan_image_path"] ?? '',
      panNo: data["pan_number"] ?? '',
      state: data["state"] ?? '',
      pincode: data["pincode"] ?? '',
      aadharNo: data["aadhar_no"] ?? '',
      dlFile: data["other_documents_files"]?["DRVLC"] ?? '',
    );
  }

  Map<String, dynamic> toMap(MeonUserDataDetails meon) {
    return {
      "aadhar_address": meon.aadharAddress,
      "aadhar_filename": meon.adharFileName,
      "aadhar_img_filename": meon.aadharImageFileName,
      "adharimg": meon.aadharImge,
      "date_time": meon.date,
      "fathername": meon.fatherName,
      "dob": meon.dob,
      "dist": meon.district,
      "gender": meon.gender,
      "house": meon.house,
      "locality": meon.locality,
      "name": meon.name,
      "name_on_pan": meon.nameOnPan,
      "pan_image_path": meon.panImagePath,
      "pan_number": meon.panNo,
      "state": meon.state,
      "pincode": meon.pincode,
      "aadhar_no": meon.aadharNo,
      "other_documents_files": {"DRVLC": meon.dlFile},
    };
  }

  @override
  String toString() {
    return 'MeonUserDataDetails(aadharAddress: $aadharAddress, adharFileName: $adharFileName, aadharImageFileName: $aadharImageFileName, aadharImge: $aadharImge, date: $date, fatherName: $fatherName, dob: $dob, district: $district, gender: $gender, house: $house, locality: $locality, name: $name, nameOnPan: $nameOnPan, panImagePath: $panImagePath, panNo: $panNo, state: $state, pincode: $pincode, aadharNo: $aadharNo, dlno: $dlFile)';
  }
}
