enum UserRole { master, manager, user }

extension UserRoleX on UserRole {
  String get asString => switch (this) {
    UserRole.master => 'MASTER',
    UserRole.manager => 'MANAGER',
    UserRole.user => 'USER',
  };

  static UserRole fromString(String v) {
    final up = v.toUpperCase();
    if (up == 'MASTER') return UserRole.master;
    if (up == 'MANAGER') return UserRole.manager;
    return UserRole.user;
  }
}
