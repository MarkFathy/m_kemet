import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/gender_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/experience_level_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/qualification_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/repositories/job_seeker_repository.dart';

class JobSeekerLookupsResult {
  final List<ProfessionEntity> professions;
  final List<ExperienceLevelEntity> experienceLevels;
  final List<QualificationEntity> qualifications;
  final List<CountryEntity> countries;
  final List<GenderEntity> genders;

  const JobSeekerLookupsResult({
    required this.professions,
    required this.experienceLevels,
    required this.qualifications,
    required this.countries,
    required this.genders,
  });
}

class GetJobSeekerLookupsUseCase {
  final JobSeekerRepository repository;

  GetJobSeekerLookupsUseCase(this.repository);

  Future<Either<Failure, JobSeekerLookupsResult>> call() async {
    try {
      final professionsRes = await repository.getProfessions();
      final expLevelsRes = await repository.getExperienceLevels();
      final qualificationsRes = await repository.getQualifications();
      final countriesRes = await repository.getCountries();
      final gendersRes = await repository.getGenders();

      List<ProfessionEntity> professions = [];
      List<ExperienceLevelEntity> expLevels = [];
      List<QualificationEntity> qualifications = [];
      List<CountryEntity> countries = [];
      List<GenderEntity> genders = [];

      professionsRes.fold((_) => null, (data) => professions = data);
      expLevelsRes.fold((_) => null, (data) => expLevels = data);
      qualificationsRes.fold((_) => null, (data) => qualifications = data);
      countriesRes.fold((_) => null, (data) => countries = data);
      gendersRes.fold((_) => null, (data) => genders = data);

      return Right(
        JobSeekerLookupsResult(
          professions: professions,
          experienceLevels: expLevels,
          qualifications: qualifications,
          countries: countries,
          genders: genders,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }
}
