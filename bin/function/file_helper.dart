import 'dart:convert';
import 'dart:io';

class FileHelper {
  FileHelper.createFile(String path) {
    File(path).create(recursive: true);
  }

  FileHelper.writeFile(String pathandFileName, String content) {
    File(pathandFileName).writeAsString(content);
  }

  Map<String, dynamic> dataResultMapping = <String, dynamic>{};

  get dataMapping => dataResultMapping;

  FileHelper.readFileSync(String path) {
    String contents = File(path).readAsStringSync();
    dataResultMapping = jsonDecode(contents) as Map<String, dynamic>;
  }

  FileHelper.readFileAsync() {
    File('./assets/user.json').readAsString().then((c) => print(c));
  }

  
}
