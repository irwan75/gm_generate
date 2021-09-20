

extension StringCustom on String {

  String toClassName() {
    return convertToClassName(this);
  }

  String toValidVariableName() {
    return convertToVariableName(this);
  }
}

String convertToVariableName(String text) {
  final List<String> words = text.split('_');
  String namaClass = "";
  if (words.length >= 2) {
    for (int i = 0; i < words.length; i++) {
      final String firstLetter;
      final String remainingLetters;
      if (i == 0) {
        firstLetter = words[i].trim().substring(0, 1).toLowerCase();
      } else {
        firstLetter = words[i].trim().substring(0, 1).toUpperCase();
      }
      remainingLetters = words[i].trim().substring(1);
      namaClass += firstLetter + remainingLetters;
    }
  } else {
    final String firstLetter = words[0].trim().substring(0, 1).toLowerCase();
    final String remainingLetters = words[0].trim().substring(1);
    namaClass += firstLetter + remainingLetters;
  }
  return namaClass;
}

String convertToClassName(String text) {
  final List<String> words = text.split('_');
  String namaClass = "";
  for (var value in words) {
    final String firstLetter = value.trim().substring(0, 1).toUpperCase();
    final String remainingLetters = value.trim().substring(1);
    namaClass += firstLetter + remainingLetters;
  }
  return namaClass;
}
