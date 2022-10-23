import 'package:fluent_ui/fluent_ui.dart';
import 'package:library_management_desktop_app/model/book.dart';
import 'package:library_management_desktop_app/pages/widgets/books_page.dart';
import 'package:library_management_desktop_app/provider/books_provider.dart';
import 'package:library_management_desktop_app/sql/sql.dart';
import 'package:provider/provider.dart';

class ContentDialogBox extends StatefulWidget {
  final int? uniqueid;
  final String? name, authour, givento;
  final bool? isavail;
  const ContentDialogBox(
      {super.key,
      this.uniqueid,
      this.name,
      this.authour,
      this.givento,
      this.isavail});

  @override
  State<ContentDialogBox> createState() => _ContentDialogBoxState();
}

class _ContentDialogBoxState extends State<ContentDialogBox> {
  TextEditingController uniqueid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController authour = TextEditingController();
  TextEditingController givento = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isavail = true;

  @override
  void initState() {
    uniqueid.text = widget.uniqueid!.toString();
    name.text = widget.name!;
    authour.text = widget.authour!;
    givento.text = widget.givento ?? "";
    isavail = widget.isavail!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Edit book'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormBox(
                    enabled: false,
                    controller: uniqueid,
                    minHeight: 40,
                    placeholder: 'Unique ID',
                  ),
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
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.orange),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text("Update"),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await Provider.of<BooksProvider>(
                              context,
                              listen: false,
                            ).updateBooks(
                              Book(
                                uniqueid: int.parse(uniqueid.text),
                                name: name.text,
                                authour: authour.text,
                                isavailable: isavail,
                                givento: givento.text,
                              ),
                            );

                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
