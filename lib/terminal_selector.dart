import 'package:dart_console/dart_console.dart';

class TerminalSelector {
  int _selectedIndex = 0;
  final _console = Console();

  final List<String> options;

  TerminalSelector({required this.options});

  int run() {
    _console.hideCursor();

    while (true) {
      for (var i = 0; i < options.length; i++) {
        final option = options[i];
        if (i == _selectedIndex) {
          _console.setForegroundColor(ConsoleColor.yellow);
          _console.writeLine('$option (selected)');
        } else {
          _console.resetColorAttributes();
          _console.writeLine(option);
        }
      }

      final key = _console.readKey();
      if (key.controlChar == ControlCharacter.arrowDown) {
        _selectedIndex = (_selectedIndex + 1) % options.length;
      } else if (key.controlChar == ControlCharacter.arrowUp) {
        _selectedIndex = (_selectedIndex - 1) % options.length;
      } else if (key.controlChar == ControlCharacter.enter) {
        break;
      }
      _console.write('\x1b[${options.length}A');
    }

    _console.resetColorAttributes();
    _console.showCursor();

    return _selectedIndex;
  }
}
