class ContactRequestModel {
  final int id;
  final int? employerId;
  final String? employerName;
  final String? employerLogo;
  final String? message;
  final String? status;
  final String? statusLabel;
  final String? profession;
  final String? createdAt;

  const ContactRequestModel({
    required this.id,
    this.employerId,
    this.employerName,
    this.employerLogo,
    this.message,
    this.status,
    this.statusLabel,
    this.profession,
    this.createdAt,
  });

  factory ContactRequestModel.fromJson(Map<String, dynamic> json) {
    final employer = json['employer'] is Map<String, dynamic>
        ? json['employer'] as Map<String, dynamic>
        : (json['company'] is Map<String, dynamic>
            ? json['company'] as Map<String, dynamic>
            : null);

    final candidate = json['candidate'] is Map<String, dynamic>
        ? json['candidate'] as Map<String, dynamic>
        : null;

    final name = employer != null
        ? (employer['name'] ?? employer['company_name'])?.toString()
        : (json['employer_name'] ??
            json['company_name'] ??
            candidate?['name'] ??
            json['name'])
            ?.toString();

    final logo = employer != null
        ? (employer['logo'] ?? employer['logo_url'])?.toString()
        : (json['employer_logo'] ??
            json['logo_url'] ??
            candidate?['profile_photo'])
            ?.toString();

    return ContactRequestModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      employerId: employer != null
          ? (employer['id'] is int
              ? employer['id'] as int
              : int.tryParse('${employer['id']}'))
          : (json['employer_id'] is int
              ? json['employer_id'] as int
              : int.tryParse('${json['employer_id']}')),
      employerName: name,
      employerLogo: logo,
      message: json['message']?.toString() ?? json['notes']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      statusLabel: json['status_label']?.toString(),
      profession: json['profession']?.toString() ??
          candidate?['profession_title']?.toString(),
      createdAt: json['created_at']?.toString() ?? json['request_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employer_id': employerId,
      'employer_name': employerName,
      'employer_logo': employerLogo,
      'message': message,
      'status': status,
      'status_label': statusLabel,
      'profession': profession,
      'created_at': createdAt,
    };
  }
}
