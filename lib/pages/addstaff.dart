import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:library_management_desktop_app/model/staff.dart';
import 'package:library_management_desktop_app/provider/staffs_provider.dart';
import 'package:library_management_desktop_app/sql/sql.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  TextEditingController staffid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool staffavail = false;

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
                  controller: staffid,
                  minHeight: 40,
                  placeholder: 'staff ID',
                  onChanged: (value) async {
                    if (value.length > 2) {
                      staffavail =
                          await SqlHelper().checkUser(int.parse(value));

                      log(staffavail.toString());

                      setState(() {});
                    }
                    ;
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Provide a staff id';
                    } else if (staffavail) {
                      return 'Staff already available in database';
                    }
                    return null;
                  }),
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
                    } else if (!EmailValidator.validate(email.text)) {
                      return 'Provide a valid email';
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
                      setState(() {
                        staffid.text = "";
                        name.text = "";
                        email.text = "";
                      });
                    },
                  ),
                  TextButton(
                    child: const Text("Add"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await SqlHelper().insertStaff(
                          Staff(
                            staffid: int.parse(staffid.text),
                            name: name.text,
                            email: email.text,
                          ),
                        );

                        StaffProvider().staffs.add(
                              Staff(
                                staffid: int.parse(staffid.text),
                                name: name.text,
                                email: email.text,
                              ),
                            );

                        setState(() {
                          staffid.text = "";
                          name.text = "";
                          email.text = "";
                        });
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
