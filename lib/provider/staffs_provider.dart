import 'package:flutter/cupertino.dart';
import 'package:library_management_desktop_app/model/staff.dart';
import 'package:library_management_desktop_app/sql/sql.dart';

class StaffProvider extends ChangeNotifier {
  List<Staff> staffs = [];
  List<Staff> searchResult = [];

  bool searching = false;
  String? searchtermstaff;

  Future<void> searchStaffs(String searchTerm) async {
    searching = searchTerm.isNotEmpty;
    searchtermstaff = searchTerm;

    searchResult = await SqlHelper().searchStaffs(searchTerm);

    notifyListeners();
  }

  void setStaffs(List<Staff> staffs) {
    this.staffs = staffs;

    notifyListeners();
  }

  Future<void> updateStaffs(Staff staff) async {
    await SqlHelper().updateStaff(staff);

    Staff existingStaff =
        staffs.where((staff1) => staff1.staffid == staff.staffid).first;

    staffs[staffs.indexOf(existingStaff)] = staff;

    notifyListeners();
  }

  void removeBook(Staff staff) {
    SqlHelper().deletestaff(staff.staffid);
    staffs.remove(staff);

    notifyListeners();
  }
}
