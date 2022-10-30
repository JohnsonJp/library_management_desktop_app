import 'dart:developer';
import 'package:library_management_desktop_app/model/book.dart';
import 'package:library_management_desktop_app/model/borrow.dart';
import 'package:library_management_desktop_app/model/staff.dart';
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
        if (error == "MySQLServerException [1146]: Table 'lib_man.book' doesn't exist" ||
            error ==
                "MySQLServerException [1146]: Table 'lib_man.borrow' doesn't exist" ||
            error ==
                "MySQLServerException [1146]: Table 'lib_man.staff' doesn't exist") {
          createTable();
        }
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

  Future createTable() async {
    db = openDb();

    await db.query('''create database if not exists lib_man''');

    await db.query('''CREATE TABLE IF NOT EXISTS book(
   name text     NOT NULL,
   authour text     NOT NULL,
   uniqueid int NOT NULL,
   isavailable bool NOT NULL,
   givento text   
);''');

    await db.query('''CREATE TABLE IF NOT EXISTS staff(
   name text     NOT NULL,
   email text     NOT NULL,
   staffid int NOT NULL
);''');

    await db.query('''CREATE TABLE IF NOT EXISTS borrow(
	id int primary key auto_increment,
   uniqueid int NOT NULL,
   staffid int NOT NULL,
   givendate datetime not null,
   returndate datetime
);''');

    await db.close();
  }

  //books table
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

    return books;
  }

  Future<List<Book>> searchBook(
      String search, String searchType, bool isreturn) async {
    db = openDb();

    searchType = searchType == "Book" ? "name" : "givento";

    ResultFormat books1;

    books1 = (!isreturn)
        ? await db
            .query('select * from book where $searchType like "%$search%"')
        : await db.query(
            'select * from book where givento IS NOT NULL and $searchType like "%$search%"');
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

  Future<Book?> isavailable(int bookid) async {
    db = openDb();
    List book = await db.getAll(
        table: 'book', where: {'uniqueid': bookid}, debug: true);
    await db.close();

    if (book.isNotEmpty) {
      return book.map((e) => Book.fromMap(e)).first;
    }

    return null;
  }

  List<Staff> staffs = [];
  //staff table
  Future<List<Staff>> getStaffs() async {
    db = openDb();
    List staff1 = await db.getAll(
      table: 'staff',
      fields: '*',
      debug: true,
    );
    await db.close();

    staffs = staff1.map((e) => Staff.fromMap(e)).toList();
    return staffs;
  }

  Future<void> insertStaff(Staff staff) async {
    db = openDb();
    await db.insert(
      table: 'staff',
      insertData: staff.toMap(),
    );
    await db.close();
  }

  Future<void> updateStaff(Staff staff) async {
    db = openDb();
    await db.update(
        table: 'staff',
        updateData: staff.toMap(),
        where: {'staffid': staff.staffid});
    await db.close();
  }

  Future<List<Staff>> searchStaffs(String search) async {
    db = openDb();

    ResultFormat staff1 =
        await db.query('select * from staff where name like "%$search%"');
    await db.close();

    return staff1.rows.map((e) => Staff.fromMap(e)).toList();
  }

  Future<void> deletestaff(int staffid) async {
    db = openDb();
    await db.delete(
      table: 'staff',
      where: {'staffid': staffid},
      debug: true,
    );
    await db.close();
  }

  //borrow table
  List<Borrow> borrows = [];

  Future<void> insertBorrow(Borrow borrow) async {
    db = openDb();
    await db.insert(table: 'borrow', insertData: borrow.toMap());
    await db.update(
        table: 'book',
        updateData: {'givento': borrow.staffid, 'isavailable': false},
        where: {'uniqueid': borrow.uniqueid});
    await db.close();
  }

  Future<List<Borrow>> getborrow() async {
    db = openDb();
    ResultFormat rs = await db.query(
        ' select book.name as bookname,borrow.uniqueid,borrow.id,borrow.staffid,staff.name as staffname,borrow.givendate,borrow.returndate  from borrow left join book on borrow.uniqueid=book.uniqueid left join staff on borrow.staffid=staff.staffid;');
    borrows = rs.rows.map((e) => Borrow.fromMap(e)).toList();

    db.close();

    return rs.rows.map((e) => Borrow.fromMap(e)).toList();
  }

  // Future<List<Borrow>> getborrow() async {
  //   db = openDb();
  //   List borrow1 = await db.getAll(table: 'borrow', fields: '*', debug: true);
  //   await db.close();

  //   borrows = borrow1.map((e) => Borrow.fromMap(e)).toList();

  //   return borrows;
  // }

  Future<void> updateBorrow(Borrow borrow) async {
    db = openDb();
    await db.update(table: 'borrow', updateData: {
      'returndate': borrow.returndate
    }, where: {
      'uniqueid': borrow.uniqueid,
      'staffid': borrow.staffid,
      'givendate': borrow.givendate
    });

    await db.update(
        table: 'book',
        updateData: {'givento': null, 'isavailable': true},
        where: {'uniqueid': borrow.uniqueid});

    await db.close();
  }

  late Borrow borrowinfo;
  Future<Borrow> getBorrowInformation(int uniqueid) async {
    db = openDb();
    List borrow1 =
        await db.getAll(table: 'borrow', where: {'uniqueid': uniqueid});

    borrowinfo = borrow1.map((e) => Borrow.fromMap(e)).toList().first;
    return borrowinfo;
  }

  Future<bool> checkUser(int id) async {
    db = openDb();

    int count = await db.count(
      table: "staff",
      where: {"staffid": id},
    );

    return count > 0;
  }

  Future<bool> checkBook(int id) async {
    db = openDb();

    int count = await db.count(
      table: "book",
      where: {"uniqueid": id},
    );
    log(count.toString());

    return count > 0;
  }
}
