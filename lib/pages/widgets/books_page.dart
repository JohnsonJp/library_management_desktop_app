import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:library_management_desktop_app/provider/books_provider.dart';
import 'package:provider/provider.dart';

import '../../model/book.dart';
import '../../utils/contentdialog.dart';

class BooksPage extends StatelessWidget {
  BooksPage({super.key});

  List<Book> books = [];

  @override
  Widget build(BuildContext context) {
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
                          flex: 4,
                          child: Text("Unique Id"),
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
                            flex: 4,
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
                                    return ContentDialogBox(
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
  String Searchobject = "Book";

  @override
  Widget build(BuildContext context) {
    return Consumer<BooksProvider>(
        builder: (_, BooksProvider booksProvider, __) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                child: DropDownButton(
                  title: Text(Searchobject),
                  items: [
                    DropDownButtonItem(
                      onTap: () {
                        setState(() {
                          Searchobject = "Book";
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
                          Searchobject = "Staff";
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
            child: TextFormBox(
                onChanged: (value) {
                  booksProvider.searchBooks(value);
                },
                minHeight: 40,
                placeholder:
                    Searchobject == "Book" ? 'Book name' : 'Staff name',
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Provide a book name';
                  }
                  return null;
                }),
          ),
        ],
      );
    });
  }
}
