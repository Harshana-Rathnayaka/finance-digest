import 'package:finance_digest/constants/app_colors.dart';
import 'package:finance_digest/models/user.dart';
import 'package:finance_digest/utils/custom_exception.dart';
import 'package:finance_digest/utils/helper_methods.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  final dbName = 'news.db';
  final createUserTable = 'CREATE TABLE users (userId INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT UNIQUE, lastName TEXT UNIQUE)';

  // creating the db and the user table
  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return openDatabase(path, version: 1, onCreate: (db, version) async => await db.execute(createUserTable));
  }

  // method to enter user data into the db
  Future<int?> signUp(User user) async {
    final Database db = await initDb();

    try {
      // checking if the user exists
      final List<Map<String, dynamic>> existingUsers = await db.query('users', where: 'firstName = ? AND lastName = ?', whereArgs: [user.firstName, user.lastName]);

      // returns the userId if the user exists.
      if (existingUsers.isNotEmpty) {
        showToast(msg: 'User already exists with the provided first and last name. Continuing to the app', backGroundColor: AppColors.hintColor);
        //  always the first value because the fields are unique
        return existingUsers.first['userId'];
      } else {
        // enters the data into db if the user does not exist and then return the userId
        final int value = await db.insert('users', user.toJson());
        return value;
      }
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        showToast(msg: 'First name or last name already exists. Please choose different values.', backGroundColor: AppColors.errorColor);
      } else {
        showToast(msg: 'An error occurred while saving data. Please try again.', backGroundColor: AppColors.errorColor);
      }
    } catch (e) {
      showToast(msg: 'An unexpected error occurred. Please try again.', backGroundColor: AppColors.errorColor);
      throw CustomException('Unexpected error: ${e.toString()}');
    }
    return null;
  }

  // method to get the user data from the db
  Future<List?> getUser(int userId) async {
    final Database db = await initDb();

    try {
      var result = await db.rawQuery("SELECT * FROM users WHERE userId = ?", [userId]);

      if (result.isNotEmpty) {
        return result;
      } else {
        showToast(msg: 'No user found with the specified ID', backGroundColor: AppColors.errorColor);
        return null;
      }
    } on DatabaseException catch (e) {
      showToast(msg: 'Failed to retrieve user data. Please try again.', backGroundColor: AppColors.errorColor);
    } catch (e) {
      showToast(msg: 'An unexpected error occurred while retrieving user data.', backGroundColor: AppColors.errorColor);
    }
    return null;
  }
}
