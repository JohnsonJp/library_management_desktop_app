import 'package:flutter/cupertino.dart';
import 'package:library_management_desktop_app/model/borrow.dart';
import 'package:library_management_desktop_app/sql/sql.dart';

class BorrowProvider extends ChangeNotifier {
  List<Borrow> history = [];

  void setHistory(List<Borrow> history) {
    this.history = history;

    notifyListeners();
  }

  Future<void> insertBorrow(Borrow borrow) async {
    await SqlHelper().insertBorrow(borrow);

    history.add(borrow);

    notifyListeners();
  }

  Future<void> updateBorrow(Borrow borrow) async {
    await SqlHelper().updateBorrow(borrow);

    Borrow oldBorrow =
        history.where((borrow1) => borrow1.uniqueid == borrow.uniqueid).first;
    history[history.indexOf(oldBorrow)] = borrow;

    notifyListeners();
  }
}
