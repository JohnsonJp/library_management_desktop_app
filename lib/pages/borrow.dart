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
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Id"),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Book name"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Staff name"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Given Data"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Return Date"),
                              ),
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
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(borrowProvider.history[index].id
                                      .toString()),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(borrowProvider
                                      .history[index].bookname
                                      .toString()),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(borrowProvider
                                      .history[index].staffname
                                      .toString()),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(borrowProvider
                                      .history[index].givendate
                                      .toString()),
                                ),
                              ),
                              Expanded(
                                flex: 2,
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
