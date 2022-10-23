import 'package:fluent_ui/fluent_ui.dart';
import 'package:library_management_desktop_app/model/book.dart';

import '../sql/sql.dart';

class BooksProvider extends ChangeNotifier {
  List<Book> books = [];
  List<Book> searchResult = [];

  String searchType = "Book";
  bool searching = false;

  Future<void> searchBooks(String searchTerm) async {
    searching = searchTerm.isNotEmpty;

    searchResult = await SqlHelper().searchBook(searchTerm, searchType);

    notifyListeners();
  }

  void setBooks(List<Book> books) {
    this.books = books;

    notifyListeners();
  }

  Future<void> updateBooks(Book book) async {
    await SqlHelper().updateBook(book);

    Book existingBook =
        books.where((book1) => book1.uniqueid == book.uniqueid).first;

    books[books.indexOf(existingBook)] = book;

    notifyListeners();
  }

  void removeBook(Book book) {
    SqlHelper().deleteBook(book.uniqueid);
    books.remove(book);

    notifyListeners();
  }
}
