import 'package:fluent_ui/fluent_ui.dart';
import 'package:library_management_desktop_app/model/staff.dart';
import 'package:library_management_desktop_app/provider/staffs_provider.dart';
import 'package:library_management_desktop_app/utils/staffcontentbox.dart';
import 'package:provider/provider.dart';

class StaffsPage extends StatelessWidget {
  StaffsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Staff> staffs = [];
    return Consumer<StaffProvider>(
      builder: (_, StaffProvider staffProvider, __) {
        if (staffProvider.searching) {
          staffs = staffProvider.searchResult;
        } else {
          staffs = staffProvider.staffs;
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
                      "Total Staffs: ${staffProvider.staffs.length}",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 20),
                    if (staffProvider.searching)
                      Text(
                        "Total search results: ${staffProvider.searchResult.length}",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: staffProvider.searchResult.isEmpty
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ),
                  ],
                ),
              ),
              if (staffs.isNotEmpty)
                Expanded(
                  flex: 2,
                  child: ListTile(
                    title: Row(
                      children: const [
                        Expanded(
                          flex: 4,
                          child: Text("Staff Id"),
                        ),
                        Expanded(
                          flex: 10,
                          child: Text("Staff Name"),
                        ),
                        Expanded(
                          flex: 10,
                          child: Text("Mail id"),
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
                  itemCount: staffs.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(staffs[i].staffid.toString()),
                          ),
                          Expanded(
                            flex: 10,
                            child: Text(staffs[i].name),
                          ),
                          Expanded(
                            flex: 10,
                            child: Text(staffs[i].email),
                          ),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              icon: const Icon(FluentIcons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StaffContentBox(
                                      staffid: staffs[i].staffid,
                                      name: staffs[i].name,
                                      email: staffs[i].email,
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
                                staffProvider.removeBook(staffs[i]);
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

  @override
  Widget build(BuildContext context) {
    return Consumer<StaffProvider>(
        builder: (_, StaffProvider staffProvider, __) {
      return TextFormBox(
          onChanged: (value) {
            staffProvider.searchStaffs(value);
          },
          minHeight: 40,
          placeholder: 'Staff name',
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Provide a staff name';
            }
            return null;
          });
    });
  }
}