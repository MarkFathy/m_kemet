import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final UserType userType;
  final bool isVerified;
  final String? status;
  final int? countryId;
  final String? countryName;
  final String? countryCode;
  final String? countryFlag;
  final String? birthDate;
  final int? genderId;
  final String? gender;
  final String? avatar;
  final String? companyName;
  final String? crNumber;
  final String? location;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.userType,
    this.phone,
    this.isVerified = false,
    this.status,
    this.countryId,
    this.countryName,
    this.countryCode,
    this.countryFlag,
    this.birthDate,
    this.genderId,
    this.gender,
    this.avatar,
    this.companyName,
    this.crNumber,
    this.location,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phone,
        userType,
        isVerified,
        status,
        countryId,
        countryName,
        countryCode,
        countryFlag,
        birthDate,
        genderId,
        gender,
        avatar,
        companyName,
        crNumber,
        location,
      ];
}
