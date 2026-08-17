import 'package:m_kemet/src/features/company/data/models/candidate_model.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';

abstract class CandidateLocalDataSource {
  Future<List<CandidateModel>> getCandidates();
  Future<List<CandidateModel>> filterCandidates(CandidateFilterEntity filter);
  Future<List<CandidateModel>> getSavedCandidates();
  Future<CandidateModel> toggleSaveCandidate(String candidateId);
}

class CandidateLocalDataSourceImpl implements CandidateLocalDataSource {
  final List<CandidateModel> _mockCandidates = [
    const CandidateModel(
      id: 'cand_1',
      name: 'أحمد محمود حسن',
      profession: 'سائق شاحنة نقل ثقيل',
      experienceYears: '7 سنوات',
      qualification: 'دبلوم متوسط',
      languages: 'العربية، الإنجليزية (مبتدئ)',
      gender: 'ذكر',
      age: 32,
      currentCountry: 'مصر',
      targetCountries: 'السعودية، الإمارات',
      isValidPassport: true,
      isVerified: true,
      isSaved: false,
      photoUrl: 'https://i.pravatar.cc/300?img=11',
      introVideoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
      cvUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      expectedSalary: '3,500 ريال سعودي',
      bio: 'سائق محترف يمتلك رخصة قيادة عمومية سارية المفعول ولديه خبرة عالية في القيادة عبر الطرق الدولية والالتزام بضوابط السلامة.',
    ),
    const CandidateModel(
      id: 'cand_2',
      name: 'سارة خالد البقمي',
      profession: 'ممرضة رعاية مركزة',
      experienceYears: '5 سنوات',
      qualification: 'بكالوريوس تمريض',
      languages: 'العربية، الإنجليزية (متقدم)',
      gender: 'أنثى',
      age: 28,
      currentCountry: 'مصر',
      targetCountries: 'السعودية، الكويت، قطر',
      isValidPassport: true,
      isVerified: true,
      isSaved: true,
      photoUrl: 'https://i.pravatar.cc/300?img=47',
      introVideoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
      cvUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      expectedSalary: '5,000 ريال سعودي',
      bio: 'أخصائية تمريض مرخصة مع خبرة عمل سابقة في المستشفيات الكبرى، متخصصة في عناية الحالات الحرجة والطوارئ.',
    ),
    const CandidateModel(
      id: 'cand_3',
      name: 'محمد عبد العزيز السيد',
      profession: 'مهندس تنفيذ مدني',
      experienceYears: '8 سنوات',
      qualification: 'بكالوريوس هندسة مدنية',
      languages: 'العربية، الإنجليزية (ممتاز)',
      gender: 'ذكر',
      age: 34,
      currentCountry: 'مصر',
      targetCountries: 'السعودية، الإمارات، عمان',
      isValidPassport: true,
      isVerified: true,
      isSaved: false,
      photoUrl: 'https://i.pravatar.cc/300?img=12',
      introVideoUrl: '',
      cvUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      expectedSalary: '8,000 ريال سعودي',
      bio: 'مهندس مدني متخصص في الإشراف على مشاريع البنية التحتية والمنشآت السكنية، يمتلك خبرة في إدارة الطواقم الميدانية.',
    ),
    const CandidateModel(
      id: 'cand_4',
      name: 'فاطمة الزهراء علي',
      profession: 'شيف طاهي شرقي وغربي',
      experienceYears: '6 سنوات',
      qualification: 'دبلوم فندقة وطهي',
      languages: 'العربية، الإنجليزية',
      gender: 'أنثى',
      age: 29,
      currentCountry: 'تونس',
      targetCountries: 'السعودية، الإمارات',
      isValidPassport: true,
      isVerified: false,
      isSaved: false,
      photoUrl: 'https://i.pravatar.cc/300?img=49',
      introVideoUrl: '',
      cvUrl: '',
      expectedSalary: '4,200 ريال سعودي',
      bio: 'طاهية محترفة في إعداد الوجبات الشرقية والغربية وتصميم قوائم الطعام للمطاعم والمؤسسات الفندقية.',
    ),
    const CandidateModel(
      id: 'cand_5',
      name: 'خالد يوسف العمراني',
      profession: 'فني كهرباء ومقاولات',
      experienceYears: '10 سنوات',
      qualification: 'معهد فني صنعتی',
      languages: 'العربية',
      gender: 'ذكر',
      age: 38,
      currentCountry: 'المغرب',
      targetCountries: 'السعودية، قطر',
      isValidPassport: false,
      isVerified: true,
      isSaved: true,
      photoUrl: 'https://i.pravatar.cc/300?img=33',
      introVideoUrl: '',
      cvUrl: '',
      expectedSalary: '3,800 ريال سعودي',
      bio: 'فني كهربائي متخصص في قراءة المخططات الهندسية وتمديد الشبكات الكهروميكانيكية في المباني الكبيرة.',
    ),
  ];

  @override
  Future<List<CandidateModel>> getCandidates() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockCandidates;
  }

  @override
  Future<List<CandidateModel>> filterCandidates(CandidateFilterEntity filter) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _mockCandidates.where((candidate) {
      if (filter.searchQuery.isNotEmpty) {
        final query = filter.searchQuery.toLowerCase();
        final matchesQuery = candidate.name.toLowerCase().contains(query) ||
            candidate.profession.toLowerCase().contains(query) ||
            candidate.currentCountry.toLowerCase().contains(query);
        if (!matchesQuery) return false;
      }

      if (filter.country != null && filter.country!.isNotEmpty) {
        if (!candidate.currentCountry.contains(filter.country!) &&
            !candidate.targetCountries.contains(filter.country!)) {
          return false;
        }
      }

      if (filter.profession != null && filter.profession!.isNotEmpty) {
        if (!candidate.profession.contains(filter.profession!)) {
          return false;
        }
      }

      if (filter.gender != null && filter.gender!.isNotEmpty) {
        if (candidate.gender != filter.gender) {
          return false;
        }
      }

      if (filter.isValidPassport != null) {
        if (candidate.isValidPassport != filter.isValidPassport) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Future<List<CandidateModel>> getSavedCandidates() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockCandidates.where((c) => c.isSaved).toList();
  }

  @override
  Future<CandidateModel> toggleSaveCandidate(String candidateId) async {
    final index = _mockCandidates.indexWhere((c) => c.id == candidateId);
    if (index != -1) {
      final old = _mockCandidates[index];
      final updated = CandidateModel.fromEntity(old.copyWith(isSaved: !old.isSaved));
      _mockCandidates[index] = updated;
      return updated;
    }
    throw Exception('Candidate not found');
  }
}
