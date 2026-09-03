import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class CandidateModel extends CandidateEntity {
  const CandidateModel({
    required super.id,
    required super.name,
    required super.profession,
    super.experienceYears,
    super.qualification,
    super.languages,
    super.gender,
    super.age,
    super.currentCountry,
    super.targetCountries,
    super.isValidPassport,
    super.isVerified,
    super.isSaved,
    super.isContactRequested,
    super.photoUrl,
    super.introVideoUrl,
    super.videoThumbnailUrl,
    super.cvUrl,
    super.expectedSalary,
    super.bio,
    super.candidateId,
    super.userId,
    super.profileId,
    super.verificationBadge,
    super.professionWithExperience,
    super.currentCountryFlag,
    super.passportStatusLabel,
    super.targetCountryNames,
    super.email,
    super.phone,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    // Current country
    String countryName = '';
    String countryFlag = '';
    if (json['current_country'] is Map<String, dynamic>) {
      final cMap = json['current_country'] as Map<String, dynamic>;
      countryName = cMap['name']?.toString() ?? '';
      countryFlag = cMap['flag']?.toString() ?? '';
    } else if (json['current_country_name'] != null) {
      countryName = json['current_country_name'].toString();
    } else if (json['currentCountry'] != null) {
      countryName = json['currentCountry'].toString();
    }

    // Target countries
    List<String> targetNames = [];
    if (json['target_country_names'] is List) {
      targetNames = (json['target_country_names'] as List)
          .map((e) => e.toString())
          .toList();
    } else if (json['target_countries'] is List) {
      for (final item in json['target_countries']) {
        if (item is Map && item['name'] != null) {
          targetNames.add(item['name'].toString());
        } else if (item is String) {
          targetNames.add(item);
        }
      }
    }
    final targetCountriesStr = targetNames.isNotEmpty
        ? targetNames.join(', ')
        : (json['targetCountries']?.toString() ?? '');

    // Passport status
    bool hasPassport = false;
    String passportLabel = '';
    if (json['passport_status'] is Map<String, dynamic>) {
      final pMap = json['passport_status'] as Map<String, dynamic>;
      hasPassport = pMap['has_passport'] == true || pMap['is_approved'] == true;
      passportLabel = pMap['status_label']?.toString() ?? '';
    }
    if (passportLabel.isEmpty && json['passport_status_label'] != null) {
      passportLabel = json['passport_status_label'].toString();
    }
    if (json['isValidPassport'] is bool) {
      hasPassport = json['isValidPassport'] as bool;
    }

    // Experience
    final profWithExp = json['profession_with_experience']?.toString() ?? '';
    String expYearsStr = '';
    if (json['experience_level'] is Map && json['experience_level']['name'] != null) {
      expYearsStr = json['experience_level']['name'].toString();
    } else if (json['experience_level'] is String && json['experience_level'].toString().isNotEmpty) {
      expYearsStr = json['experience_level'].toString();
    } else if (json['experience_level_name'] != null) {
      expYearsStr = json['experience_level_name'].toString();
    } else if (json['experience_years'] != null) {
      final expVal = json['experience_years'];
      if (expVal == 0 || expVal == '0') {
        if (profWithExp.contains('|')) {
          expYearsStr = profWithExp.split('|').last.trim();
        } else {
          expYearsStr = '';
        }
      } else {
        expYearsStr = '$expVal سنوات';
      }
    } else if (json['experienceYears'] != null) {
      expYearsStr = json['experienceYears'].toString();
    }

    // Gender
    String genderStr = '';
    if (json['gender'] is Map) {
      genderStr = json['gender']['name']?.toString() ?? '';
    } else if (json['gender'] != null) {
      genderStr = json['gender'].toString();
    }

    // Languages
    String languagesStr = '';
    if (json['languages'] is List) {
      languagesStr = (json['languages'] as List).join(', ');
    } else if (json['languages'] != null) {
      languagesStr = json['languages'].toString();
    }

    // Qualification
    String qualificationStr = '';
    if (json['qualification_text'] != null) {
      qualificationStr = json['qualification_text'].toString();
    } else if (json['qualification'] is Map) {
      qualificationStr = json['qualification']['name']?.toString() ?? '';
    } else if (json['qualification'] != null) {
      qualificationStr = json['qualification'].toString();
    }

    // Video
    String videoUrl = '';
    String videoThumbnail = '';
    if (json['video'] is Map<String, dynamic>) {
      videoUrl = json['video']['video_url']?.toString() ?? '';
      videoThumbnail = json['video']['thumbnail_url']?.toString() ?? '';
    } else if (json['video_url'] != null) {
      videoUrl = json['video_url'].toString();
    } else if (json['introVideoUrl'] != null) {
      videoUrl = json['introVideoUrl'].toString();
    }
    if (videoThumbnail.isEmpty && json['video_thumbnail_url'] != null) {
      videoThumbnail = json['video_thumbnail_url'].toString();
    }

    // Bio / Summary
    final bioStr = json['bio']?.toString() ?? json['summary']?.toString() ?? '';

    // Expected Salary
    final expectedSalaryStr = json['expected_salary']?.toString() ?? json['expectedSalary']?.toString() ?? '';

    // Contact request status
    final hasContactReq = json['already_sent'] == true ||
        json['has_contact_request'] == true ||
        json['is_contact_requested'] == true ||
        json['contact_request'] != null ||
        json['application'] != null;

    return CandidateModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      profession: json['profession_title']?.toString() ?? json['profession']?.toString() ?? '',
      experienceYears: expYearsStr,
      qualification: qualificationStr,
      languages: languagesStr,
      gender: genderStr,
      age: json['age'] is int ? json['age'] as int : int.tryParse(json['age']?.toString() ?? '0') ?? 0,
      currentCountry: countryName,
      targetCountries: targetCountriesStr,
      isValidPassport: hasPassport,
      isVerified: json['is_verified'] == true || json['isVerified'] == true,
      isSaved: json['is_bookmarked'] == true || json['isSaved'] == true,
      isContactRequested: hasContactReq,
      photoUrl: json['profile_photo']?.toString() ?? json['photoUrl']?.toString() ?? '',
      introVideoUrl: videoUrl,
      videoThumbnailUrl: videoThumbnail,
      cvUrl: json['cvUrl']?.toString() ?? '',
      expectedSalary: expectedSalaryStr,
      bio: bioStr,
      candidateId: json['candidate_id'] is int ? json['candidate_id'] as int : int.tryParse(json['candidate_id']?.toString() ?? ''),
      userId: json['user_id'] is int ? json['user_id'] as int : int.tryParse(json['user_id']?.toString() ?? ''),
      profileId: json['profile_id'] is int ? json['profile_id'] as int : int.tryParse(json['profile_id']?.toString() ?? ''),
      verificationBadge: json['verification_badge']?.toString() ?? '',
      professionWithExperience: json['profession_with_experience']?.toString() ?? '',
      currentCountryFlag: countryFlag,
      passportStatusLabel: passportLabel,
      targetCountryNames: targetNames,
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
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
      'candidate_id': candidateId,
      'user_id': userId,
      'profile_id': profileId,
      'verification_badge': verificationBadge,
      'profession_with_experience': professionWithExperience,
      'current_country_flag': currentCountryFlag,
      'passport_status_label': passportStatusLabel,
      'target_country_names': targetCountryNames,
      'email': email,
      'phone': phone,
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
      isContactRequested: entity.isContactRequested,
      photoUrl: entity.photoUrl,
      introVideoUrl: entity.introVideoUrl,
      videoThumbnailUrl: entity.videoThumbnailUrl,
      cvUrl: entity.cvUrl,
      expectedSalary: entity.expectedSalary,
      bio: entity.bio,
      candidateId: entity.candidateId,
      userId: entity.userId,
      profileId: entity.profileId,
      verificationBadge: entity.verificationBadge,
      professionWithExperience: entity.professionWithExperience,
      currentCountryFlag: entity.currentCountryFlag,
      passportStatusLabel: entity.passportStatusLabel,
      targetCountryNames: entity.targetCountryNames,
      email: entity.email,
      phone: entity.phone,
    );
  }
}
