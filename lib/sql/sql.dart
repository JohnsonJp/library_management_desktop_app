import 'dart:developer';
import 'package:library_management_desktop_app/model/book.dart';
import 'package:mysql_utils/mysql_utils.dart';

class SqlHelper {
  late MysqlUtils db;
  List<Book> books = [];

  MysqlUtils openDb() {
    var db1 = MysqlUtils(
      settings: {
        'host': '127.0.0.1',
        'port': 3306,
        'user': 'root',
        'password': 'password',
        'db': 'lib_man',
        'maxConnections': 10,
        'secure': false,
        'prefix': '',
        'pool': false,
        'collation': 'utf8mb4_general_ci',
      },
      errorLog: (error) {
        log(error);
      },
      sqlLog: (sql) {
        log(sql);
      },
      connectInit: (db1) async {
        log('whenComplete');
      },
    );
    return db1;
  }

  Future<void> insertBook(Book book) async {
    db = openDb();
    await db.insert(table: 'book', insertData: book.toMap());
    await db.close();
  }

  Future<void> updateBook(Book book) async {
    db = openDb();
    await db.update(
        table: 'book',
        updateData: book.toMap(),
        where: {'uniqueid': book.uniqueid});
    await db.close();
  }

  Future<List<Book>> getBooks() async {
    db = openDb();
    List books1 = await db.getAll(
      table: 'book',
      fields: '*',
      debug: true,
    );
    await db.close();
    books = books1.map((e) => Book.fromMap(e)).toList();

    return books1.map((e) => Book.fromMap(e)).toList();
  }

  Future<List<Book>> searchBook(String search, String searchType) async {
    db = openDb();

    searchType = searchType == "Book" ? "name" : "givento";

    ResultFormat books1 =
        await db.query('select * from book where $searchType like "%$search%"');
    await db.close();

    return books1.rows.map((e) => Book.fromMap(e)).toList();
  }

  Future<void> deleteBook(int uniqueid) async {
    db = openDb();
    await db.delete(
      table: 'book',
      where: {'uniqueid': uniqueid},
      debug: true,
    );
    await db.close();
  }
}
