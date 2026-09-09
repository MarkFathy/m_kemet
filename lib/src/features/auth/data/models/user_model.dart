import 'package:m_kemet/src/features/auth/domain/entities/user_entity.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.userType,
    super.phone,
    super.isVerified,
    super.status,
    super.countryId,
    super.countryName,
    super.countryCode,
    super.countryFlag,
    super.birthDate,
    super.genderId,
    super.gender,
    super.avatar,
    super.companyName,
    super.crNumber,
    super.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Determine UserType:
    // "company" -> UserType.employer
    // "candidate" / "job_seeker" -> UserType.jobSeeker
    UserType detectedType = UserType.jobSeeker;
    final role = (json['user_type'] ?? json['role'] ?? json['type'] ?? json['account_type'] ?? '')
        .toString()
        .trim()
        .toLowerCase();

    if (role == 'company' ||
        role == 'employer' ||
        role.contains('company') ||
        role.contains('employer') ||
        role == '2') {
      detectedType = UserType.employer;
    } else if (role == 'candidate' ||
        role == 'job_seeker' ||
        role == 'jobseeker' ||
        role.contains('candidate') ||
        role.contains('seeker') ||
        role == '1') {
      detectedType = UserType.jobSeeker;
    } else if ((json.containsKey('company_name') && json['company_name'] != null && json['company_name'].toString().trim().isNotEmpty) ||
        (json.containsKey('cr_number') && json['cr_number'] != null && json['cr_number'].toString().trim().isNotEmpty) ||
        (json.containsKey('commercial_registration') && json['commercial_registration'] != null) ||
        (json.containsKey('company') && json['company'] != null && json['company'] is Map && (json['company'] as Map).isNotEmpty)) {
      detectedType = UserType.employer;
    }

    // Extract Company object if present
    Map<String, dynamic>? companyMap;
    if (json['company'] is Map<String, dynamic>) {
      companyMap = json['company'] as Map<String, dynamic>;
    } else if (json['company'] is Map) {
      companyMap = Map<String, dynamic>.from(json['company'] as Map);
    }

    // Extract Company Name
    final String? companyName = companyMap?['name']?.toString() ??
        json['company_name']?.toString() ??
        (detectedType == UserType.employer ? json['name']?.toString() : null);

    // Extract CR Number
    final String? crNumber = companyMap?['cr_number']?.toString() ??
        companyMap?['commercial_registration']?.toString() ??
        json['cr_number']?.toString() ??
        json['commercial_registration']?.toString();

    // Extract Location
    final String? location = companyMap?['location']?.toString() ??
        companyMap?['address']?.toString() ??
        json['location']?.toString() ??
        json['address']?.toString();

    // Extract Name
    String extractedName = json['name']?.toString() ?? '';
    if (extractedName.isEmpty && companyName != null && companyName.isNotEmpty) {
      extractedName = companyName;
    }
    if (extractedName.isEmpty) {
      extractedName = json['company_name']?.toString() ?? '';
    }

    final statusStr = json['status']?.toString();
    final isVerifiedVal = json['is_verified'] ?? (statusStr == 'active') ?? (json['email_verified_at'] != null);

    // Parse Country (nested map or flat fields)
    Map<String, dynamic>? countryMap;
    if (json['current_country'] is Map<String, dynamic>) {
      countryMap = json['current_country'] as Map<String, dynamic>;
    } else if (json['country'] is Map<String, dynamic>) {
      countryMap = json['country'] as Map<String, dynamic>;
    }

    final countryId = countryMap != null
        ? (countryMap['id'] is int ? countryMap['id'] as int : int.tryParse(countryMap['id']?.toString() ?? ''))
        : (json['current_country_id'] is int
            ? json['current_country_id'] as int
            : int.tryParse(json['current_country_id']?.toString() ?? json['country_id']?.toString() ?? ''));

    final countryName = countryMap != null
        ? countryMap['name']?.toString()
        : (json['country_name']?.toString() ?? json['country']?.toString());

    final countryCode = countryMap != null
        ? countryMap['code']?.toString()
        : json['country_code']?.toString();

    final countryFlag = countryMap != null
        ? countryMap['flag']?.toString()
        : json['country_flag']?.toString();

    // Parse Gender (nested map or flat fields)
    Map<String, dynamic>? genderMap;
    if (json['gender'] is Map<String, dynamic>) {
      genderMap = json['gender'] as Map<String, dynamic>;
    }

    final genderId = genderMap != null
        ? (genderMap['id'] is int ? genderMap['id'] as int : int.tryParse(genderMap['id']?.toString() ?? ''))
        : (json['gender_id'] is int ? json['gender_id'] as int : int.tryParse(json['gender_id']?.toString() ?? ''));

    final genderName = genderMap != null
        ? genderMap['name']?.toString()
        : (json['gender'] is! Map ? json['gender']?.toString() : null);

    return UserModel(
      id: json['id']?.toString() ?? (json['user_id'] ?? companyMap?['id'])?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: extractedName,
      userType: detectedType,
      phone: json['phone']?.toString(),
      status: statusStr,
      isVerified: isVerifiedVal is bool ? isVerifiedVal : (isVerifiedVal != null && isVerifiedVal != false),
      countryId: countryId,
      countryName: countryName,
      countryCode: countryCode,
      countryFlag: countryFlag,
      birthDate: json['birth_date']?.toString(),
      genderId: genderId,
      gender: genderName,
      avatar: json['avatar']?.toString() ?? json['photo']?.toString() ?? companyMap?['logo']?.toString(),
      companyName: companyName,
      crNumber: crNumber,
      location: location,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'user_type': userType == UserType.employer ? 'company' : 'candidate',
      'status': status,
      'is_verified': isVerified,
      'current_country_id': countryId,
      'country_name': countryName,
      'country_code': countryCode,
      'country_flag': countryFlag,
      'birth_date': birthDate,
      'gender_id': genderId,
      'gender': gender,
      'avatar': avatar,
      'company_name': companyName,
      'cr_number': crNumber,
      'location': location,
    };
  }
}
