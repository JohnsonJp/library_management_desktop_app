import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:library_management_desktop_app/sql/sql.dart';

class BorrowPage extends StatelessWidget {
  const BorrowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () async {
            await SqlHelper().getborrow();
          },
          child: Text("Get Borrow")),
    );
  }
}
