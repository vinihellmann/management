import 'package:management/modules/auth/models/enums/user_role.dart';

class MemberProfile {
  MemberProfile({
    required this.uid,
    required this.role,
    required this.active,
    required this.email,
    required this.displayName,
  });

  final String uid;
  final UserRole role;
  final bool active;
  final String email;
  final String displayName;
}
