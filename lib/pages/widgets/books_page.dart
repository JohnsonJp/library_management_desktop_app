import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:library_management_desktop_app/provider/books_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../model/book.dart';
import '../../utils/bookcontentdialog.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});
  @override
  Widget build(BuildContext context) {
    List<Book> books = [];
    return Consumer<BooksProvider>(
      builder: (_, BooksProvider booksProvider, __) {
        if (booksProvider.searching) {
          books = booksProvider.searchResult;
        } else {
          books = booksProvider.books;
        }

        return Container(
          color: Colors.transparent,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: BookPageSearchBar(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      "Total books: ${booksProvider.books.length}",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 20),
                    if (booksProvider.searching)
                      Text(
                        "Total search results: ${booksProvider.searchResult.length}",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: booksProvider.searchResult.isEmpty
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ),
                  ],
                ),
              ),
              if (books.isNotEmpty)
                Expanded(
                  flex: 2,
                  child: ListTile(
                    title: Row(
                      children: const [
                        Expanded(
                          flex: 3,
                          child: Text("Id"),
                        ),
                        Expanded(
                          flex: 10,
                          child: Text("Book Name"),
                        ),
                        Expanded(
                          flex: 10,
                          child: Text("Authour Name"),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text("Edit"),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text("Delete"),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                flex: 18,
                child: ListView.builder(
                  primary: true,
                  itemCount: books.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(books[i].uniqueid.toString()),
                          ),
                          Expanded(
                            flex: 10,
                            child: Text(books[i].name),
                          ),
                          Expanded(
                            flex: 10,
                            child: Text(books[i].authour),
                          ),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              icon: const Icon(FluentIcons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BookContetBox(
                                      uniqueid: books[i].uniqueid,
                                      name: books[i].name,
                                      authour: books[i].authour,
                                      givento: books[i].givento,
                                      isavail: books[i].isavailable,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              icon: const Icon(FluentIcons.delete),
                              onPressed: () async {
                                booksProvider.removeBook(books[i]);

                                showSimpleNotification(
                                  const Text("Book deleted successfully"),
                                  background: Colors.blue,
                                  duration: const Duration(seconds: 2),
                                  position: NotificationPosition.bottom,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BookPageSearchBar extends StatefulWidget {
  const BookPageSearchBar({super.key});

  @override
  State<BookPageSearchBar> createState() => _BookPageSearchBarState();
}

class _BookPageSearchBarState extends State<BookPageSearchBar> {
  String searchobject = "Book";
  bool isreturn = false;

  TextEditingController bookNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<BooksProvider>(
        builder: (_, BooksProvider booksProvider, __) {
      if (bookNameController.text.isEmpty) {
        bookNameController.text = booksProvider.currentSearchTerm ?? "";
      }

      return Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(
                height: 40,
                child: DropDownButton(
                  title: Text(searchobject),
                  items: [
                    DropDownButtonItem(
                      onTap: () {
                        setState(() {
                          searchobject = "Book";
                        });

                        Provider.of<BooksProvider>(context, listen: false)
                            .searchType = "Book";
                        log('book');
                      },
                      title: const Text("Book"),
                    ),
                    DropDownButtonItem(
                      onTap: () {
                        setState(() {
                          searchobject = "Staff";
                        });

                        Provider.of<BooksProvider>(context, listen: false)
                            .searchType = "Staff";
                        log('Staff');
                      },
                      title: const Text("Staff"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: TextFormBox(
                  controller: bookNameController,
                  onChanged: (value) {
                    booksProvider.searchBooks(value);
                  },
                  minHeight: 40,
                  placeholder:
                      searchobject == "Book" ? 'Book name' : 'Staff name',
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Provide a book name';
                    }
                    return null;
                  }),
            ),
          ),
          Expanded(
              flex: 3,
              child: Consumer(builder: (_, BooksProvider booksProvider, __) {
                return ToggleSwitch(
                  checked: booksProvider.isreturn,
                  onChanged: (v) {
                    booksProvider.isreturn = !booksProvider.isreturn;
                    booksProvider
                        .searchBooks(booksProvider.currentSearchTerm ?? "");
                  },
                  content: const Text('Not return'),
                );
              })),
        ],
      );
    });
  }
}
