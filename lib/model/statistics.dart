// ignore_for_file: public_member_api_docs, sort_constructors_first
class Statistics {
  int totalBooksCountInDB;
  int totalAvailableBooksCount;
  int totalBorrowed;

  Statistics({
    required this.totalBooksCountInDB,
    required this.totalAvailableBooksCount,
    required this.totalBorrowed,
  });
}
