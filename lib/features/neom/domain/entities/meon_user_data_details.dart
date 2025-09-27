class MeonUserDataDetails {
  final String aadharAddress;
  final String adharFileName;
  final String aadharImageFileName;
  final String aadharImge;
  final String date;
  final String fatherName;
  final String dob;
  final String district;
  final String gender;
  final String house;
  final String locality;
  final String name;
  final String nameOnPan;
  final String panImagePath;
  final String panNo;
  final String state;
  final String pincode;
  final String aadharNo;
  final String dlFile;

  //Constructor
  const MeonUserDataDetails({
    required this.aadharAddress,
    required this.adharFileName,
    required this.aadharImageFileName,
    required this.aadharImge,
    required this.date,
    required this.fatherName,
    required this.dob,
    required this.district,
    required this.gender,
    required this.house,
    required this.locality,
    required this.name,
    required this.nameOnPan,
    required this.panImagePath,
    required this.panNo,
    required this.state,
    required this.pincode,
    required this.aadharNo,
    required this.dlFile,
  });

  List<Object?> get props => [
    aadharAddress,
    adharFileName,
    aadharImageFileName,
    aadharImge,
    date,
    fatherName,
    dob,
    district,
    gender,
    house,
    locality,
    name,
    nameOnPan,
    panImagePath,
    panNo,
    state,
    pincode,
    aadharNo,
    dlFile,
  ];
}
