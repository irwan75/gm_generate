import 'dart:io';

class FolderHelper {

  FolderHelper.createFolder(String path){
    Directory(path).create(recursive: true);
  }


}