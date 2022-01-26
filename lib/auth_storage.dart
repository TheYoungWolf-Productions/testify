import 'package:path_provider/path_provider.dart';
import 'dart:io';


class AuthStorage {
  Future<String> getLocalPath() async {
    var dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> getLocalFile() async {
    String path = await getLocalPath();
    return File('$path/auth.txt');
  }

  Future<File> writeAuth(String email, String password) async {
    File file = await getLocalFile();
    return file.writeAsString('$email' + ' ' + '$password');
  }

  Future<String> readAuth() async {
    try {
      final file = await getLocalFile();
      String content = await file.readAsString();
      return content;
    } catch(e) {
      return "";
    }
  }

  Future<String> deleteFile() async {
    try {
      final file = await getLocalFile();

      await file.delete();
      return "";
    } catch (e) {
      return "";
    }
  }
}