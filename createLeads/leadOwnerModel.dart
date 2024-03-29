

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LeadOwner {
  String name;
  String id;
  String designation;
  LeadOwner({
    required this.name,
    required this.id,
    required this.designation,
  });

  LeadOwner copyWith({
    String? name,
    String? id,
    String? designation,
  }) {
    return LeadOwner(
      name: name ?? this.name,
      id: id ?? this.id,
      designation: designation ?? this.designation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'designation': designation,
    };
  }

  factory LeadOwner.fromMap(Map<String, dynamic> map) {
    return LeadOwner(
      name: map['name'] as String,
      id: map['id'] as String,
      designation: map['designation'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LeadOwner.fromJson(String source) =>
      LeadOwner.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LeadOwner(name: $name, id: $id, designation: $designation)';

  @override
  bool operator ==(covariant LeadOwner other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.id == id &&
        other.designation == designation;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode ^ designation.hashCode;
}