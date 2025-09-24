import 'package:firebase_auth/firebase_auth.dart';
import 'package:management/modules/auth/models/enums/user_role.dart';
import 'package:management/modules/auth/models/member_profile.dart';
import 'package:management/modules/auth/models/tenant_meta.dart';

class AuthSession {
  AuthSession({
    required this.firebaseUser,
    required this.tenant,
    required this.member,
    required this.loggedAt,
  });

  final User firebaseUser;
  final TenantMeta tenant;
  final MemberProfile member;
  final DateTime loggedAt;

  bool get isExpired => DateTime.now().difference(loggedAt).inDays >= 7;

  Map<String, dynamic> toMap() {
    return {
      'loggedAt': loggedAt.millisecondsSinceEpoch,
      'tenant': {
        'cnpj': tenant.cnpj,
        'name': tenant.name,
        'active': tenant.active,
        'licenseUntil': tenant.licenseUntil?.millisecondsSinceEpoch,
      },
      'member': {
        'uid': member.uid,
        'role': member.role.asString,
        'active': member.active,
        'email': member.email,
        'displayName': member.displayName,
      },
    };
  }

  factory AuthSession.fromMap(User firebaseUser, Map<String, dynamic> data) {
    final tenantMap = (data['tenant'] as Map<String, dynamic>);
    final memberMap = (data['member'] as Map<String, dynamic>);

    final tenant = TenantMeta(
      cnpj: tenantMap['cnpj'] as String,
      name: (tenantMap['name'] as String),
      active: (tenantMap['active'] as bool?) ?? false,
      licenseUntil: (tenantMap['licenseUntil'] != null)
          ? DateTime.fromMillisecondsSinceEpoch(
              tenantMap['licenseUntil'] as int,
            )
          : null,
    );

    final member = MemberProfile(
      uid: memberMap['uid'] as String,
      role: UserRoleX.fromString((memberMap['role'] as String?) ?? 'USER'),
      active: (memberMap['active'] as bool?) ?? false,
      email: memberMap['email'] as String,
      displayName: memberMap['displayName'] as String,
    );

    final loggedAt = DateTime.fromMillisecondsSinceEpoch(
      data['loggedAt'] as int,
    );

    return AuthSession(
      firebaseUser: firebaseUser,
      tenant: tenant,
      member: member,
      loggedAt: loggedAt,
    );
  }
}
