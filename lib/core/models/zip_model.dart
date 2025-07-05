class ZipModel {
  final String zip;
  final String street;
  final String neighborhood;
  final String city;
  final String state;

  ZipModel({
    required this.zip,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  factory ZipModel.fromJson(Map<String, dynamic> json) {
    return ZipModel(
      zip: json['cep'] ?? '',
      street: json['logradouro'] ?? '',
      neighborhood: json['bairro'] ?? '',
      city: json['localidade'] ?? '',
      state: json['uf'] ?? '',
    );
  }

  @override
  String toString() {
    return '$street, $neighborhood, $city - $state';
  }
}
