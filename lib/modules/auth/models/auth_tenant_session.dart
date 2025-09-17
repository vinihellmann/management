class AuthTenantSession {
  final String tenantId;
  final bool active;
  final String document;
  final String name;
  final DateTime licenseUntil;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AuthTenantSession({
    required this.tenantId,
    required this.active,
    required this.document,
    required this.name,
    required this.licenseUntil,
    required this.createdAt,
    required this.updatedAt,
  });
}
