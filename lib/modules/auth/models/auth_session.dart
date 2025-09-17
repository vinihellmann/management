import 'package:firebase_auth/firebase_auth.dart';
import 'package:management/modules/auth/models/auth_tenant_session.dart';

class AuthSession {
  final User user;
  final AuthTenantSession tenant;
  const AuthSession({required this.user, required this.tenant});
}
