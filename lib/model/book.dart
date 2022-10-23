import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Book {
  int uniqueid;
  String name;
  String authour;
  bool isavailable;
  String? givento;
  Book({
    required this.uniqueid,
    required this.name,
    required this.authour,
    required this.isavailable,
    this.givento,
  });

  Book copyWith({
    int? uniueid,
    String? name,
    String? authour,
    bool? isavailable,
    String? givento,
  }) {
    return Book(
      uniqueid: uniueid ?? uniqueid,
      name: name ?? this.name,
      authour: authour ?? this.authour,
      isavailable: isavailable ?? this.isavailable,
      givento: givento ?? this.givento,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uniqueid': uniqueid,
      'name': name,
      'authour': authour,
      'isavailable': isavailable,
      'givento': givento,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      uniqueid: map['uniqueid'] as int,
      name: map['name'] as String,
      authour: map['authour'] as String,
      isavailable: map['isavailable'] as bool,
      givento: map['givento'] != null ? map['givento'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Book(uniqueid: $uniqueid, name: $name, authour: $authour, isavailable: $isavailable, givento: $givento)';
  }

  @override
  bool operator ==(covariant Book other) {
    if (identical(this, other)) return true;

    return other.uniqueid == uniqueid &&
        other.name == name &&
        other.authour == authour &&
        other.isavailable == isavailable &&
        other.givento == givento;
  }

  @override
  int get hashCode {
    return uniqueid.hashCode ^
        name.hashCode ^
        authour.hashCode ^
        isavailable.hashCode ^
        givento.hashCode;
  }
}
