import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:library_management_desktop_app/model/statistics.dart';
import 'package:library_management_desktop_app/sql/sql.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class Stats extends StatelessWidget {
  const Stats({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: fetchStats(),
          builder: (context, AsyncSnapshot<Statistics> future) {
            if (future.hasError) {
              log("", error: future.error);
              throw future.error!;
            }

            if (future.connectionState == ConnectionState.waiting) {
              return const ProgressRing();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Total books in library: ${future.data!.totalBooksCountInDB}"),
                const SizedBox(
                  height: 20,
                ),
                Text(
                    "Total books available in library: ${future.data!.totalAvailableBooksCount}"),
                const SizedBox(
                  height: 20,
                ),
                Text("Total books borrowed: ${future.data!.totalBorrowed}"),
              ],
            );
          }),
    );
  }

  Future<Statistics> fetchStats() async {
    int bookCountInDB = await SqlHelper().getBooksCountInDB();
    int totalAvailableBooks = await SqlHelper().getAvailableBooksCount();

    return Statistics(
      totalBooksCountInDB: bookCountInDB,
      totalAvailableBooksCount: totalAvailableBooks,
      totalBorrowed: bookCountInDB - totalAvailableBooks,
    );
  }
}
