import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:library_management_desktop_app/model/book.dart';
import 'package:library_management_desktop_app/model/borrow.dart';
import 'package:library_management_desktop_app/provider/books_provider.dart';
import 'package:library_management_desktop_app/provider/borrow_provider.dart';
import 'package:library_management_desktop_app/sql/sql.dart';
import 'package:provider/provider.dart';
import 'package:read_barcode/read_barcode.dart';

class AddBorrow extends StatefulWidget {
  const AddBorrow({super.key});

  @override
  State<AddBorrow> createState() => _AddBorrowState();
}

class _AddBorrowState extends State<AddBorrow> {
  TextEditingController bookid = TextEditingController();
  TextEditingController staffid = TextEditingController();
  late DateTime date;
  late DateTime redate;
  bool isborrowed = false;
  bool istrue = false;
  final formkey = GlobalKey<FormState>();

  bool staffavail = false;

  final barcodeReader = BarcodeReader();

  @override
  void initState() {
    date = DateTime.now();
    redate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormBox(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: bookid,
                  onChanged: (value) async {
                    if (value.length > 4) {
                      Book? book =
                          await SqlHelper().isavailable(int.parse(value));
                      if (book != null) {
                        istrue = true;
                        if (book.givento != null) {
                          if (book.givento!.isNotEmpty) ;
                          {
                            isborrowed = true;
                            Borrow borrow = await SqlHelper()
                                .getBorrowInformation(int.parse(bookid.text));
                            staffid.text = borrow.staffid.toString();
                            date = borrow.givendate;
                            redate = DateTime.now();
                          }
                        }
                      }

                      log(istrue.toString());
                    } else {
                      istrue = false;
                      staffid.text = "";
                      isborrowed = false;
                      date = DateTime.now();
                    }

                    setState(() {});
                  },
                  minHeight: 40,
                  placeholder: 'Book ID',
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Provide a book id';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 60,
                child: Visibility(
                  visible: istrue,
                  child: TextFormBox(
                      onChanged: (value) async {
                        if (value.length > 2) {
                          staffavail =
                              await SqlHelper().checkUser(int.parse(value));

                          log(staffavail.toString());

                          setState(() {});
                        }
                      },
                      controller: staffid,
                      minHeight: 40,
                      placeholder: 'Staff id',
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Provide a Staff id';
                        } else if (!staffavail) {
                          return 'Staff Not found';
                        }

                        return null;
                      }),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 16,
                child: Visibility(
                  visible: bookid.text.isNotEmpty && !istrue,
                  child: const Text("No Books Found"),
                ),
              ),
              SizedBox(
                height: 60,
                child: Visibility(
                  visible: istrue,
                  child: DatePicker(
                    header: 'Date of given',
                    selected: date,
                    onChanged: (v) => setState(() => date = v),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 60,
                child: Visibility(
                  visible: isborrowed,
                  child: DatePicker(
                    header: 'Date of return',
                    selected: redate,
                    onChanged: (v) => setState(() => redate = v),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: Visibility(
                    visible: istrue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          child: const Text("Clear"),
                          onPressed: () {
                            setState(() {
                              bookid.text = "";
                              isborrowed = false;
                              staffid.text = "";
                              istrue = false;
                            });
                          },
                        ),
                        TextButton(
                          child: (isborrowed)
                              ? const Text("Lend")
                              : const Text("Borrow"),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              BorrowProvider borrowProvider =
                                  Provider.of<BorrowProvider>(context,
                                      listen: false);

                              (isborrowed)
                                  ? borrowProvider.updateBorrow(
                                      Borrow(
                                        uniqueid: int.parse(bookid.text),
                                        staffid: int.parse(staffid.text),
                                        givendate: date,
                                        returndate: redate,
                                      ),
                                    )
                                  : borrowProvider.insertBorrow(
                                      Borrow(
                                        uniqueid: int.parse(bookid.text),
                                        staffid: int.parse(staffid.text),
                                        givendate: date,
                                      ),
                                    );

                              BooksProvider booksProvider =
                                  Provider.of<BooksProvider>(context,
                                      listen: false);

                              int index = booksProvider.books.indexWhere(
                                  (book) =>
                                      book.uniqueid == int.parse(bookid.text));

                              booksProvider.books[index] =
                                  booksProvider.books[index].copyWith(
                                isavailable: isborrowed,
                                givento: isborrowed ? null : staffid.text,
                              );

                              setState(() {
                                bookid.text = "";
                                staffid.text = "";
                                isborrowed = false;
                                istrue = false;
                              });
                            }
                          },
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkUser() async {
    return SqlHelper().checkUser(int.parse(staffid.text));
  }
}
