import 'package:fluent_ui/fluent_ui.dart';
import 'package:library_management_desktop_app/model/book.dart';
import 'package:library_management_desktop_app/pages/widgets/books_page.dart';
import 'package:library_management_desktop_app/provider/books_provider.dart';
import 'package:library_management_desktop_app/sql/sql.dart';
import 'package:provider/provider.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late Future<List<Book>> getBooksFuture;

  @override
  void initState() {
    super.initState();
    getBooksFuture = SqlHelper().getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BooksProvider>(
        builder: (_, BooksProvider booksProvider, __) {
      return booksProvider.books.isEmpty
          ? FutureBuilder(
              future: getBooksFuture,

              builder: (_, AsyncSnapshot future) {
                if (future.hasError) throw future.error!;

                if (future.connectionState == ConnectionState.done) {
                  booksProvider.books = future.data;

                  return BooksPage();
                }

                return const Center(child: ProgressRing());
              },
            )
          : BooksPage();
    });
  }
}
