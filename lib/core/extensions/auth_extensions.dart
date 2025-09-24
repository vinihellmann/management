import 'package:flutter/material.dart';
import 'package:management/modules/auth/controllers/auth_controller.dart';
import 'package:management/modules/auth/models/auth_session.dart';
import 'package:management/modules/auth/models/enums/auth_status.dart';
import 'package:management/modules/auth/models/enums/user_role.dart';
import 'package:management/modules/auth/models/member_profile.dart';
import 'package:management/modules/auth/models/tenant_meta.dart';
import 'package:provider/provider.dart';

extension AuthContextX on BuildContext {
  AuthController get auth => watch<AuthController>();

  AuthSession? get session => auth.session;
  TenantMeta? get tenant => session?.tenant;
  MemberProfile? get member => session?.member;

  bool get isLoggedIn => auth.status == AuthStatus.authenticated;

  bool get isMaster => member?.role == UserRole.master;
  bool get isManager => member?.role == UserRole.manager || isMaster;
  bool get isUserOnly => member?.role == UserRole.user;
}
