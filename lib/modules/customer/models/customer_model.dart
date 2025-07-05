import 'package:management/core/models/base_model.dart';

class CustomerModel extends BaseModel {
  String? name;
  String? fantasy;
  String? document;
  String? email;
  String? phone;
  String? address;
  String? neighborhood;
  String? number;
  String? city;
  String? state;
  String? contact;
  String? zipcode;
  String? complement;

  CustomerModel({
    super.id,
    super.code,
    super.createdAt,
    super.updatedAt,
    this.name,
    this.fantasy,
    this.document,
    this.email,
    this.phone,
    this.address,
    this.neighborhood,
    this.number,
    this.city,
    this.state,
    this.contact,
    this.zipcode,
    this.complement,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'fantasy': fantasy,
      'document': document,
      'email': email,
      'phone': phone,
      'address': address,
      'neighborhood': neighborhood,
      'number': number,
      'city': city,
      'state': state,
      'contact': contact,
      'zipcode': zipcode,
      'complement': complement,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  CustomerModel fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      fantasy: map['fantasy'],
      document: map['document'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      neighborhood: map['neighborhood'],
      number: map['number'],
      city: map['city'],
      state: map['state'],
      contact: map['contact'],
      zipcode: map['zipcode'],
      complement: map['complement'],
      createdAt: DateTime.tryParse(map['createdAt']),
      updatedAt: DateTime.tryParse(map['updatedAt']),
    );
  }
}
