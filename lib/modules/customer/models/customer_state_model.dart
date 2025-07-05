class CustomerStateModel {
  final int id;
  final String name;
  final String acronym;

  CustomerStateModel({
    required this.id,
    required this.name,
    required this.acronym,
  });

  factory CustomerStateModel.fromMap(Map<String, dynamic> map) {
    return CustomerStateModel(
      id: map['id'],
      name: map['name'],
      acronym: map['acronym'],
    );
  }
}
