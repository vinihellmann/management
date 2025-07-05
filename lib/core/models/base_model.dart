abstract class BaseModel {
  int? id;
  String? code;
  DateTime? createdAt;
  DateTime? updatedAt;

  BaseModel({
    this.id,
    this.code,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap();

  BaseModel fromMap(Map<String, dynamic> map);
}
