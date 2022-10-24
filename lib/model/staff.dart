import 'dart:convert';

class Staff {
  int staffid;
  String name;
  String email;
  Staff({
    required this.staffid,
    required this.name,
    required this.email,
  });

  Staff copyWith({
    int? staffid,
    String? name,
    String? email,
  }) {
    return Staff(
      staffid: staffid ?? this.staffid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'staffid': staffid,
      'name': name,
      'email': email,
    };
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      staffid: map['staffid'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Staff.fromJson(String source) => Staff.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Staff(staffid: $staffid, name: $name, email: $email)';

  @override
  bool operator ==(covariant Staff other) {
    if (identical(this, other)) return true;
  
    return 
      other.staffid == staffid &&
      other.name == name &&
      other.email == email;
  }

  @override
  int get hashCode => staffid.hashCode ^ name.hashCode ^ email.hashCode;
}
