import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:library_management_desktop_app/model/staff.dart';
import 'package:library_management_desktop_app/provider/staffs_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class StaffContentBox extends StatefulWidget {
  final int? staffid;
  final String? name, email;

  const StaffContentBox({super.key, this.staffid, this.name, this.email});

  @override
  State<StaffContentBox> createState() => _StaffContentBoxState();
}

class _StaffContentBoxState extends State<StaffContentBox> {
  TextEditingController staffid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController givento = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    staffid.text = widget.staffid!.toString();
    name.text = widget.name!;
    email.text = widget.email!;

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
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    enabled: false,
                    controller: staffid,
                    minHeight: 40,
                    placeholder: 'Staff ID',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormBox(
                      controller: name,
                      minHeight: 40,
                      placeholder: 'Staff name',
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Provide a staff name';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormBox(
                      controller: email,
                      minHeight: 40,
                      placeholder: 'Mail id',
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Provide a mail id';
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
                            await Provider.of<StaffProvider>(
                              context,
                              listen: false,
                            ).updateStaffs(
                              Staff(
                                  staffid: widget.staffid!,
                                  name: name.text,
                                  email: email.text),
                            );

                            Navigator.pop(context);
                          }

                          showSimpleNotification(
                            const Text("User updated successfully"),
                            background: Colors.blue,
                            duration: const Duration(seconds: 2),
                            position: NotificationPosition.bottom,
                          );
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
