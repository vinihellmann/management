import 'package:firebase_auth/firebase_auth.dart';
import 'package:management/modules/auth/enums/auth_role_enum.dart';
import 'package:management/modules/auth/models/auth_tenant_session.dart';

class AuthSession {
  final User user;
  final UserRole userRole;
  final AuthTenantSession tenant;

  const AuthSession({
    required this.user,
    required this.userRole,
    required this.tenant,
  });
}
