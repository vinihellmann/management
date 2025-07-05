class CustomerCityModel {
  final int id;
  final String name;
  final int stateId;

  CustomerCityModel({
    required this.id,
    required this.name,
    required this.stateId,
  });

  factory CustomerCityModel.fromMap(Map<String, dynamic> map) {
    return CustomerCityModel(
      id: map['id'],
      name: map['name'],
      stateId: map['state_id'],
    );
  }
}
