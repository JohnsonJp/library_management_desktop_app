// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Borrow {
  int uniqueid;
  int staffid;
  DateTime givendate;
  DateTime? returndate;
  Borrow({
    required this.uniqueid,
    required this.staffid,
    required this.givendate,
    this.returndate,
  });
 

  Borrow copyWith({
    int? uniqueid,
    int? staffid,
    DateTime? givendate,
    DateTime? returndate,
  }) {
    return Borrow(
      uniqueid: uniqueid ?? this.uniqueid,
      staffid: staffid ?? this.staffid,
      givendate: givendate ?? this.givendate,
      returndate: returndate ?? this.returndate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uniqueid': uniqueid,
      'staffid': staffid,
      'givendate': givendate,
      'returndate': returndate,
    };
  }

  factory Borrow.fromMap(Map<String, dynamic> map) {
    return Borrow(
      uniqueid: map['uniqueid'] as int,
      staffid: map['staffid'] as int,
      givendate: DateTime.parse(map['givendate'] ),
      returndate: map['returndate'] != null ? DateTime.parse(map['returndate']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Borrow.fromJson(String source) => Borrow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Borrow(uniqueid: $uniqueid, staffid: $staffid, givendate: $givendate, returndate: $returndate)';
  }

  @override
  bool operator ==(covariant Borrow other) {
    if (identical(this, other)) return true;
  
    return 
      other.uniqueid == uniqueid &&
      other.staffid == staffid &&
      other.givendate == givendate &&
      other.returndate == returndate;
  }

  @override
  int get hashCode {
    return uniqueid.hashCode ^
      staffid.hashCode ^
      givendate.hashCode ^
      returndate.hashCode;
  }
}
