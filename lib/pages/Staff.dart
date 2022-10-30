import 'package:fluent_ui/fluent_ui.dart';
import 'package:library_management_desktop_app/model/staff.dart';
import 'package:library_management_desktop_app/pages/widgets/staffpage.dart';
import 'package:library_management_desktop_app/provider/staffs_provider.dart';
import 'package:library_management_desktop_app/sql/sql.dart';
import 'package:provider/provider.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  late Future<List<Staff>> getStaffsFuture;

  @override
  void initState() {
    super.initState();
    getStaffsFuture = SqlHelper().getStaffs();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StaffProvider>(
        builder: (_, StaffProvider staffProvider, __) {
      return staffProvider.staffs.isEmpty
          ? FutureBuilder(
              future: getStaffsFuture,
              builder: (_, AsyncSnapshot future) {
                if (future.hasError) throw future.error!;

                if (future.connectionState == ConnectionState.done) {
                  if (future.data!.isEmpty) {
                    return const Center(
                      child: Text("No Staff's found..."),
                    );
                  }
                  staffProvider.staffs = future.data;

                  return const StaffsPage();
                }

                return const Center(child: ProgressRing());
              },
            )
          : const StaffsPage();
    });
  }
}
