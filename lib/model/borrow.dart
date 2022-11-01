// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Borrow {
  int? id;
  int uniqueid;
  int staffid;
  DateTime givendate;
  DateTime? returndate;
  String? staffname;
  String? bookname;

  Borrow({
    this.id,
    required this.uniqueid,
    required this.staffid,
    required this.givendate,
    this.returndate,
    this.staffname,
    this.bookname,
  });

  Borrow copyWith({
    int? id,
    int? uniqueid,
    int? staffid,
    DateTime? givendate,
    DateTime? returndate,
    String? staffname,
    String? bookname,
  }) {
    return Borrow(
      id: id ?? this.id,
      uniqueid: uniqueid ?? this.uniqueid,
      staffid: staffid ?? this.staffid,
      givendate: givendate ?? this.givendate,
      returndate: returndate ?? this.returndate,
      staffname: staffname ?? this.staffname,
      bookname: bookname ?? this.bookname,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uniqueid': uniqueid,
      'staffid': staffid,
      'givendate': givendate,
      'returndate': returndate
    };
  }

  Map<String, dynamic> toMapJsonSafe() {
    return <String, dynamic>{
      'uniqueid': uniqueid,
      'staffid': staffid,
      'givendate': givendate.toString(),
      'returndate': returndate.toString()
    };
  }

  factory Borrow.fromMap(Map<String, dynamic> map) {
    return Borrow(
      id: map['id'] != null ? map['id'] as int : null,
      uniqueid: map['uniqueid'] as int,
      staffid: map['staffid'] as int,
      givendate: DateTime.parse(map['givendate']),
      returndate:
          map['returndate'] != null ? DateTime.parse(map['returndate']) : null,
      staffname: map['staffname'] != null ? map['staffname'] as String : null,
      bookname: map['bookname'] != null ? map['bookname'] as String : null,
    );
  }

  String toJson() => json.encode(toMapJsonSafe());

  factory Borrow.fromJson(String source) =>
      Borrow.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Borrow.fromSafeJson(String source) {
    Map<String, dynamic> data = json.decode(source) as Map<String, dynamic>;

    data["givendate"] = data["givendate"] == "null" ? null : data["givendate"];
    data["returndate"] =
        data["returndate"] == "null" ? null : data["returndate"];

    return Borrow.fromMap(data);
  }

  @override
  String toString() {
    return 'Borrow(id: $id, uniqueid: $uniqueid, staffid: $staffid, givendate: $givendate, returndate: $returndate, staffname: $staffname, bookname: $bookname)';
  }

  @override
  bool operator ==(covariant Borrow other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uniqueid == uniqueid &&
        other.staffid == staffid &&
        other.givendate == givendate &&
        other.returndate == returndate &&
        other.staffname == staffname &&
        other.bookname == bookname;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uniqueid.hashCode ^
        staffid.hashCode ^
        givendate.hashCode ^
        returndate.hashCode ^
        staffname.hashCode ^
        bookname.hashCode;
  }
}
