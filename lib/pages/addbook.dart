import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:library_management_desktop_app/model/book.dart';
import 'package:library_management_desktop_app/provider/books_provider.dart';
import 'package:library_management_desktop_app/sql/sql.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  TextEditingController uniqueid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController authour = TextEditingController();
  TextEditingController givento = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isavail = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormBox(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: uniqueid,
                  minHeight: 40,
                  placeholder: 'Unique ID',
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Provide a unique id';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 10,
              ),
              TextFormBox(
                  controller: name,
                  minHeight: 40,
                  placeholder: 'Book name',
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Provide a book name';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 10,
              ),
              TextFormBox(
                  controller: authour,
                  minHeight: 40,
                  placeholder: 'Authour name',
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Provide a authour name';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ToggleSwitch(
                    checked: isavail,
                    content: const Text("Is available"),
                    onChanged: (value) {
                      setState(() {
                        isavail = value;
                      });
                    },
                  ),
                ],
              ),
              if (!isavail)
                const SizedBox(
                  height: 10,
                ),
              if (!isavail)
                TextFormBox(
                    controller: givento,
                    minHeight: 40,
                    placeholder: 'Given To',
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Provide a Staff name';
                      }
                      return null;
                    }),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: const Text("Clear"),
                    onPressed: () {
                      name.text = "";
                      authour.text = "";
                      uniqueid.text = "";
                      givento.text = "";
                      isavail = true;
                    },
                  ),
                  TextButton(
                    child: const Text("Add"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await SqlHelper().insertBook(
                          Book(
                            uniqueid: int.parse(uniqueid.text),
                            name: name.text,
                            authour: authour.text,
                            isavailable: isavail,
                            givento: givento.text,
                          ),
                        );

                        BooksProvider().books.add(
                              Book(
                                uniqueid: int.parse(uniqueid.text),
                                name: name.text,
                                authour: authour.text,
                                isavailable: isavail,
                                givento: givento.text,
                              ),
                            );

                        name.text = "";
                        authour.text = "";
                        uniqueid.text = "";
                        givento.text = "";
                        isavail = true;
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
