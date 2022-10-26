import 'package:fluent_ui/fluent_ui.dart';
import 'package:library_management_desktop_app/model/borrow.dart';
import 'package:library_management_desktop_app/provider/borrow_provider.dart';
import 'package:library_management_desktop_app/sql/sql.dart';
import 'package:provider/provider.dart';

class BorrowPage extends StatelessWidget {
  const BorrowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SqlHelper().getborrow(),
      builder: (_, AsyncSnapshot<List<Borrow>> future) {
        if (future.hasError) throw future.error!;

        if (future.connectionState == ConnectionState.done) {
          return Consumer<BorrowProvider>(
              builder: (_, BorrowProvider borrowProvider, __) {
            borrowProvider.history = future.data!;

            return Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  if (borrowProvider.history.isNotEmpty)
                    Expanded(
                      flex: 2,
                      child: ListTile(
                        title: Row(
                          children: const [
                            Expanded(
                              flex: 4,
                              child: Text("Unique Id"),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("Staff Id"),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("Given Data"),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("Return Date"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 18,
                    child: ListView.builder(
                      itemCount: borrowProvider.history.length,
                      itemBuilder: (_, index) {
                        return SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(borrowProvider
                                    .history[index].uniqueid
                                    .toString()),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(borrowProvider
                                    .history[index].staffid
                                    .toString()),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(borrowProvider
                                    .history[index].givendate
                                    .toString()),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                    (borrowProvider.history[index].returndate ??
                                            "Not returned")
                                        .toString()),
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
          });
        }

        return const Center(child: ProgressRing());
      },
    );
  }
}
