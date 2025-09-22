enum UserRole {
  master,
  manager,
  user;

  static UserRole fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'MASTER':
        return UserRole.master;
      case 'MANAGER':
        return UserRole.manager;
      case 'USER':
      default:
        return UserRole.user;
    }
  }

  String get asString {
    switch (this) {
      case UserRole.master:
        return 'MASTER';
      case UserRole.manager:
        return 'MANAGER';
      case UserRole.user:
        return 'USER';
    }
  }
}
