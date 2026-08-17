import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class CandidateModel extends CandidateEntity {
  const CandidateModel({
    required super.id,
    required super.name,
    required super.profession,
    required super.experienceYears,
    required super.qualification,
    required super.languages,
    required super.gender,
    required super.age,
    required super.currentCountry,
    required super.targetCountries,
    required super.isValidPassport,
    required super.isVerified,
    super.isSaved,
    required super.photoUrl,
    required super.introVideoUrl,
    required super.cvUrl,
    required super.expectedSalary,
    required super.bio,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profession: json['profession'] as String,
      experienceYears: json['experienceYears'] as String,
      qualification: json['qualification'] as String,
      languages: json['languages'] as String,
      gender: json['gender'] as String,
      age: json['age'] as int,
      currentCountry: json['currentCountry'] as String,
      targetCountries: json['targetCountries'] as String,
      isValidPassport: json['isValidPassport'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
      photoUrl: json['photoUrl'] as String? ?? '',
      introVideoUrl: json['introVideoUrl'] as String? ?? '',
      cvUrl: json['cvUrl'] as String? ?? '',
      expectedSalary: json['expectedSalary'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profession': profession,
      'experienceYears': experienceYears,
      'qualification': qualification,
      'languages': languages,
      'gender': gender,
      'age': age,
      'currentCountry': currentCountry,
      'targetCountries': targetCountries,
      'isValidPassport': isValidPassport,
      'isVerified': isVerified,
      'isSaved': isSaved,
      'photoUrl': photoUrl,
      'introVideoUrl': introVideoUrl,
      'cvUrl': cvUrl,
      'expectedSalary': expectedSalary,
      'bio': bio,
    };
  }

  factory CandidateModel.fromEntity(CandidateEntity entity) {
    return CandidateModel(
      id: entity.id,
      name: entity.name,
      profession: entity.profession,
      experienceYears: entity.experienceYears,
      qualification: entity.qualification,
      languages: entity.languages,
      gender: entity.gender,
      age: entity.age,
      currentCountry: entity.currentCountry,
      targetCountries: entity.targetCountries,
      isValidPassport: entity.isValidPassport,
      isVerified: entity.isVerified,
      isSaved: entity.isSaved,
      photoUrl: entity.photoUrl,
      introVideoUrl: entity.introVideoUrl,
      cvUrl: entity.cvUrl,
      expectedSalary: entity.expectedSalary,
      bio: entity.bio,
    );
  }
}
