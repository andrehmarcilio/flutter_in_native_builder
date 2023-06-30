import 'dart:io';

class TerminalCommand {
  static Future<void> deleteFile(String filePath) async {
    if (Platform.isWindows) {
      Directory(filePath).deleteSync(recursive: true);
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
