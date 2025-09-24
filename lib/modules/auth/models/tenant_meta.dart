class TenantMeta {
  TenantMeta({
    required this.cnpj,
    required this.name,
    required this.active,
    required this.licenseUntil,
  });

  final String cnpj;
  final String name;
  final bool active;
  final DateTime? licenseUntil;

  bool get licenseValid {
    if (!active) return false;
    if (licenseUntil == null) return true;
    return DateTime.now().isBefore(licenseUntil!);
  }
}
