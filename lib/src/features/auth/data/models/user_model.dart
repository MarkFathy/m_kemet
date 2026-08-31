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
    super.birthDate,
    super.genderId,
    super.gender,
    super.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Determine UserType
    UserType detectedType = UserType.jobSeeker;
    final role = (json['user_type'] ?? json['role'] ?? json['type'] ?? '').toString().toLowerCase();
    if (role.contains('company') || role.contains('employer')) {
      detectedType = UserType.employer;
    } else if (json.containsKey('company') || json.containsKey('company_name') || json.containsKey('cr_number')) {
      detectedType = UserType.employer;
    }

    // Extract Name
    String extractedName = json['name']?.toString() ?? json['company_name']?.toString() ?? '';
    if (extractedName.isEmpty && json['company'] is Map<String, dynamic>) {
      extractedName = (json['company'] as Map<String, dynamic>)['name']?.toString() ?? '';
    }

    final isVerifiedVal = json['is_verified'] ?? (json['email_verified_at'] != null);
    final statusStr = json['status']?.toString();

    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: extractedName,
      userType: detectedType,
      phone: json['phone']?.toString(),
      status: statusStr,
      isVerified: isVerifiedVal is bool ? isVerifiedVal : (isVerifiedVal != null && isVerifiedVal != false),
      countryId: json['current_country_id'] is int
          ? json['current_country_id'] as int
          : int.tryParse(json['current_country_id']?.toString() ?? ''),
      countryName: json['country']?['name']?.toString() ?? json['country_name']?.toString(),
      birthDate: json['birth_date']?.toString(),
      genderId: json['gender_id'] is int
          ? json['gender_id'] as int
          : int.tryParse(json['gender_id']?.toString() ?? ''),
      gender: json['gender']?.toString(),
      avatar: json['avatar']?.toString() ?? json['photo']?.toString(),
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
      'birth_date': birthDate,
      'gender_id': genderId,
      'gender': gender,
      'avatar': avatar,
    };
  }
}
