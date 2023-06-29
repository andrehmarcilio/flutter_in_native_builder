import 'dart:io';

class TerminalCommand {
  static void deleteFile(String filePath) {
    if (Platform.isWindows) {
      Process.runSync(
        'rmdir',
        ['/s', filePath],
        runInShell: true,
      );
    } else {
      Process.runSync('rm', ['-r', filePath]);
    }
  }

  static void movieFile({required String initialPath, required String destinationPath}) {
    if (Platform.isWindows) {
      Process.runSync(
        'move',
        [initialPath, destinationPath],
        runInShell: true,
      );
    } else {
      Process.runSync('mv', [
        initialPath,
        destinationPath,
      ]);
    }
  }
}
