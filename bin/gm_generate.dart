import 'dart:convert';

import 'function/argument_checked.dart';
import 'function/file_helper.dart';
import 'function/helper_view.dart';
import 'models/argument_checked_return.dart';
import 'utils/print_color.dart';
import './extension/string_extension.dart';

void main(List<String> arguments) async {
  ArgumentCheckedReturn resultArgumentChecked =
      await argumentChecked(arguments);
  (resultArgumentChecked.isSuccess)
      ? createPathDataModel(resultArgumentChecked.filePathFull, resultArgumentChecked.directoryTemporary)
      : showCommandsExample();
}

void showCommandsExample() {
  Logger.error("\n====Wrong Commands====\n");
  HelperView.getInstance.showHelpLevel1();
  HelperView.getInstance.exampleCLI();
}

int maxLimit = 50;
List<List<Map<String, dynamic>>> dataModelGenerate = [];
List<String> dataCollectString = [];

void createPathDataModel(String filePathFull, String directoryTemporary) {
  try {
    final dataConvert = FileHelper.readFileSync(filePathFull);

    var fileName = (filePathFull.split('/').last).split('.').first;

    var pathFileandName = '$directoryTemporary$fileName.dart';

    FileHelper.createFile(pathFileandName);

    for (int i = 1; i < maxLimit; i++) {
      dataModelGenerate.add([]);
      dataCollectString.add("");
    }
    Future.delayed(Duration(seconds: 1)).then((value) =>
        initializeParentModel(dataConvert, fileName, pathFileandName));
  } on Exception catch (_) {
    Logger.error("\nInside Json File is invalid!!\n\n");
  }
}

void initializeParentModel(
    FileHelper dataConvert, String fileName, String pathComplete) {
  int i = 0;
  dataCollectString[i] += "import 'dart:convert';\n\n";

  dataCollectString[i] += 'class ${fileName.toClassName()}{\n';

  dataConvert.dataResultMapping.forEach((key, value) {
    if (value.runtimeType
        .toString()
        .contains('_InternalLinkedHashMap<String, dynamic>')) {
      dataCollectString[i] += '  ${key.toClassName()} ${key.toValidVariableName()};\n';

      dataModelGenerate[i].add({
        'nameClass': key.toClassName(),
        'valueClass': json.encode(dataConvert.dataResultMapping[key])
      });
    } else if (value.runtimeType.toString().contains('List<dynamic>')) {
      dataCollectString[i] += '  List<${key.toClassName()}> ${key.toValidVariableName()};\n';

      dataModelGenerate[i].add({
        'nameClass': key.toClassName(),
        'valueClass': json.encode(dataConvert.dataResultMapping[key][0])
      });
    } else {
      dataCollectString[i] += '  ${value.runtimeType.toString()} ${key.toValidVariableName()};\n';
    }
  });
  i++;
  dataCollectString[i] += '\n';
  dataCollectString[i] += '  ${fileName.toClassName()}({\n';
  dataConvert.dataResultMapping.forEach((key, value) {
    dataCollectString[i] += '    required this.${key.toValidVariableName()},\n';
  });
  dataCollectString[i] += '  });\n\n';

  dataCollectString[i] += '  Map<String, dynamic> toMap(){\n';
  dataCollectString[i] += '    return{\n';
  dataConvert.dataResultMapping.forEach((key, value) {
    if (value.runtimeType
        .toString()
        .contains('_InternalLinkedHashMap<String, dynamic>')) {
      dataCollectString[i] += "      '$key': ${key.toValidVariableName()}.toMap(),\n";
    } else if (value.runtimeType.toString().contains('List<dynamic>')) {
      dataCollectString[i] += "      '$key': ${key.toValidVariableName()}.map((x)=> x.toMap()).toList(),\n";
    } else {
      dataCollectString[i] += "      '$key': ${key.toValidVariableName()},\n";
    }
  });
  dataCollectString[i] += '    };\n';
  dataCollectString[i] += '  }\n\n';

  dataCollectString[i] +=
      '  factory ${fileName.toClassName()}.fromMap(Map<String, dynamic> map) {\n';
  dataCollectString[i] += '    return ${fileName.toClassName()}(\n';

  dataConvert.dataResultMapping.forEach((key, value) {
    if (value.runtimeType
        .toString()
        .contains('_InternalLinkedHashMap<String, dynamic>')) {
      dataCollectString[i] +=
          "      ${key.toValidVariableName()}: ${key.toClassName()}.fromMap(map['$key']),\n";
    } else if (value.runtimeType.toString().contains('List<dynamic>')) {
      dataCollectString[i] +=
          "      ${key.toValidVariableName()}: List<${key.toClassName()}>.from(map['$key']?.map((x)=> ${key.toClassName()}.fromMap(x))),\n";
    } else {
      dataCollectString[i] += "      ${key.toValidVariableName()}: map['$key'] ?? ${getValueNullSafety(value.runtimeType.toString())},\n";
    }
  });

  dataCollectString[i] += '    );\n';
  dataCollectString[i] += '  }\n\n';

  dataCollectString[i] += '  String toJson() => json.encode(toMap());\n\n';
  dataCollectString[i] +=
      '  factory ${fileName.toClassName()}.fromJson(String source) => ${fileName.toClassName()}.fromMap(json.decode(source));\n\n';

  dataCollectString[i] += '}\n\n';

  getDataChildModel(pathComplete);
}

void getDataChildModel(String pathComplete) {
  for (int i = 1; i < maxLimit; i++) {
    generateChildModel(i);
  }
  var valueCollect = "";
  for (var value in dataCollectString) {
    valueCollect += value;
  }

  FileHelper.writeFile(pathComplete, valueCollect);
  Logger.successfull("\nCreate Class Model Successfull!!\n\n");
}

void generateChildModel(int i) {
  for (int a = 0; a < dataModelGenerate[i - 1].length; a++) {
    dataCollectString[i] +=
        'class ${dataModelGenerate[i - 1][a]['nameClass']}{\n';

    var result = jsonDecode(dataModelGenerate[i - 1][a]['valueClass'])
        as Map<String, dynamic>;

    result.forEach((key, value) {
      if (value.runtimeType
          .toString()
          .contains('_InternalLinkedHashMap<String, dynamic>')) {
        dataCollectString[i] += '  ${key.toClassName()} ${key.toValidVariableName()};\n';

        dataModelGenerate[i].add({
          'nameClass': key.toClassName(),
          'valueClass': json.encode(result[key])
        });
      } else if (value.runtimeType.toString().contains('List<dynamic>')) {
        dataCollectString[i] += '  List<${key.toClassName()}> ${key.toValidVariableName()};\n';

        dataModelGenerate[i].add({
          'nameClass': key.toClassName(),
          'valueClass': json.encode(result[key][0])
        });
      } else {
        dataCollectString[i] += '  ${value.runtimeType.toString()} ${key.toValidVariableName()};\n';
      }
    });
    dataCollectString[i] += '\n';
    dataCollectString[i] += '  ${dataModelGenerate[i - 1][a]['nameClass']}({\n';
    result.forEach((key, value) {
      dataCollectString[i] += '    required this.${key.toValidVariableName()},\n';
    });
    dataCollectString[i] += '  });\n\n';

    dataCollectString[i] += '  Map<String, dynamic> toMap(){\n';
    dataCollectString[i] += '    return{\n';
    result.forEach((key, value) {
      if (value.runtimeType
          .toString()
          .contains('_InternalLinkedHashMap<String, dynamic>')) {
        dataCollectString[i] += "      '$key': ${key.toValidVariableName()}.toMap(),\n";
      } else if (value.runtimeType.toString().contains('List<dynamic>')) {
        dataCollectString[i] += "      '$key': ${key.toValidVariableName()}.map((x)=> x.toMap()).toList(),\n";
      } else {
        dataCollectString[i] += "      '$key': ${key.toValidVariableName()},\n";
      }
    });
    dataCollectString[i] += '    };\n';
    dataCollectString[i] += '  }\n\n';

    dataCollectString[i] +=
        '  factory ${dataModelGenerate[i - 1][a]['nameClass']}.fromMap(Map<String, dynamic> map) {\n';
    dataCollectString[i] +=
        '    return ${dataModelGenerate[i - 1][a]['nameClass']}(\n';

    result.forEach((key, value) {
      if (value.runtimeType
          .toString()
          .contains('_InternalLinkedHashMap<String, dynamic>')) {
        dataCollectString[i] +=
            "      ${key.toValidVariableName()}: ${key.toClassName()}.fromMap(map['$key']),\n";
      } else if (value.runtimeType.toString().contains('List<dynamic>')) {
        dataCollectString[i] +=
            "      ${key.toValidVariableName()}: List<${key.toClassName()}>.from(map['$key']?.map((x)=> ${key.toClassName()}.fromMap(x))),\n";
      } else {
        dataCollectString[i] += "      ${key.toValidVariableName()}: map['$key'] ?? ${getValueNullSafety(value.runtimeType.toString())},\n";
      }
    });

    dataCollectString[i] += '    );\n';
    dataCollectString[i] += '  }\n\n';

    dataCollectString[i] += '  String toJson() => json.encode(toMap());\n\n';
    dataCollectString[i] +=
        '  factory ${dataModelGenerate[i - 1][a]['nameClass']}.fromJson(String source) => ${dataModelGenerate[i - 1][a]['nameClass']}.fromMap(json.decode(source));\n\n';

    dataCollectString[i] += '}\n\n';
  }
}

dynamic getValueNullSafety(String value) {
  switch (value) {
    case 'String':
      return "''";
    case 'int':
      return 0;
    case 'double':
      return 0.0;
    case 'bool':
      return false;
    default:
      return "''";
  }
}