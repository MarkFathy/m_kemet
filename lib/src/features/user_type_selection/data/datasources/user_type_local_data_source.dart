import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserTypeLocalDataSource {
  Future<void> saveUserType(UserType userType);
  Future<UserType?> getUserType();
}

class UserTypeLocalDataSourceImpl implements UserTypeLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _userTypeKey = 'SELECTED_USER_TYPE';

  UserTypeLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveUserType(UserType userType) async {
    await sharedPreferences.setString(_userTypeKey, userType.name);
  }

  @override
  Future<UserType?> getUserType() async {
    final String? value = sharedPreferences.getString(_userTypeKey);
    if (value == null) return null;
    return UserType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserType.jobSeeker,
    );
  }
}
