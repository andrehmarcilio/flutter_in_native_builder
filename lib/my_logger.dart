class MyLogger {
  static void log(dynamic value, {ColorCodes? color}) {
    if (color != null) {
      print(color.interpolate(value.toString()));
    } else {
      print(value);
    }
  }
}

enum ColorCodes {
  red('\u001b[31m'),
  green('\u001b[32m'),
  yellow('\u001b[33m'),
  blue('\u001b[34m');

  final String code;

  const ColorCodes(this.code);

  String interpolate(String value) {
    return '$code$value\u001b[0m';
  }
}
