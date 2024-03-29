import 'dart:convert';

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class GenderTypes {
  static const String MALE = 'MALE';
  static const String FEMALE = 'FEMALE';
  static const String PREFER_NOT_TO_SAY = 'PREFER_NOT_TO_SAY';
}

class LeadPersonalDetails {
  String name;
  String mobileNo;
  String? email;
  String? companyName;
  String? designation;
  String? industry;
  String? phone;
  String? gender;
  String? dpUrl;
  LeadPersonalDetails({
    required this.name,
    required this.mobileNo,
    this.email,
    this.companyName,
    this.designation,
    this.industry,
    this.phone,
    this.gender,
    this.dpUrl,
  });

  LeadPersonalDetails copyWith({
    String? name,
    String? mobileNo,
    String? email,
    String? companyName,
    String? designation,
    String? industry,
    String? phone,
    String? gender,
    String? dpUrl,
  }) {
    return LeadPersonalDetails(
      name: name ?? this.name,
      mobileNo: mobileNo ?? this.mobileNo,
      email: email ?? this.email,
      companyName: companyName ?? this.companyName,
      designation: designation ?? this.designation,
      industry: industry ?? this.industry,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dpUrl: dpUrl ?? this.dpUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'mobileNo': mobileNo,
      'email': email,
      'companyName': companyName,
      'designation': designation,
      'industry': industry,
      'phone': phone,
      'gender': gender,
      'dpUrl': dpUrl,
    };
  }

  factory LeadPersonalDetails.fromMap(Map<String, dynamic> map) {
    return LeadPersonalDetails(
      name: map['name'] as String,
      mobileNo: map['mobileNo'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      companyName:
          map['companyName'] != null ? map['companyName'] as String : null,
      designation:
          map['designation'] != null ? map['designation'] as String : null,
      industry: map['industry'] != null ? map['industry'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      dpUrl: map['dpUrl'] != null ? map['dpUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LeadPersonalDetails.fromJson(String source) =>
      LeadPersonalDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LeadPersonalDetails(name: $name, mobileNo: $mobileNo, email: $email, companyName: $companyName, designation: $designation, industry: $industry, phone: $phone, gender: $gender, dpUrl: $dpUrl)';
  }

  @override
  bool operator ==(covariant LeadPersonalDetails other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.mobileNo == mobileNo &&
        other.email == email &&
        other.companyName == companyName &&
        other.designation == designation &&
        other.industry == industry &&
        other.phone == phone &&
        other.gender == gender &&
        other.dpUrl == dpUrl;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        mobileNo.hashCode ^
        email.hashCode ^
        companyName.hashCode ^
        designation.hashCode ^
        industry.hashCode ^
        phone.hashCode ^
        gender.hashCode ^
        dpUrl.hashCode;
  }
}