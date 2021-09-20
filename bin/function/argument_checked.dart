import 'dart:io';
import '../models/argument_checked_return.dart';
import '../utils/print_color.dart';
import './folder_helper.dart';

Future<ArgumentCheckedReturn> argumentChecked(List<String> arguments) async {
  String filePathFull = '';
  String directoryTemporary = '';

  if (arguments.isNotEmpty && arguments.length == 5) {
    if (arguments[0] == 'generate' && arguments[1] == 'model') {
      var checkFileExist =
          await File(Directory.current.path + '/' + arguments[2]).exists();
      if (checkFileExist) {
        filePathFull = Directory.current.path + '/' + arguments[2];
        if (arguments[3] == 'on') {
          if (arguments[4].substring(arguments[4].length - 1) == '/') {
            directoryTemporary = Directory.current.path + '/' + arguments[4];
            FolderHelper.createFolder(directoryTemporary);
            return ArgumentCheckedReturn(
                filePathFull: filePathFull,
                directoryTemporary: directoryTemporary,
                isSuccess: true);
          } else {
            directoryTemporary =
                Directory.current.path + '/' + arguments[4] + '/';
            FolderHelper.createFolder(directoryTemporary);
            return ArgumentCheckedReturn(
                filePathFull: filePathFull,
                directoryTemporary: directoryTemporary,
                isSuccess: true);
          }
        }
      } else {
        Logger.error("\n====Your File Doesn't Exist====");
        return ArgumentCheckedReturn();
      }
    }
  }
  return ArgumentCheckedReturn();
}
