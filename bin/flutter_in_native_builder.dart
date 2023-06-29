import 'dart:convert';
import 'dart:io';

import 'package:flutter_in_native_builder/flutter_module_projects.dart';
import 'package:flutter_in_native_builder/models/project.dart';
import 'package:flutter_in_native_builder/my_logger.dart';
import 'package:flutter_in_native_builder/terminal_commands.dart';
import 'package:flutter_in_native_builder/terminal_selector.dart';

void main(List<String> arguments) async {
  final projectNames = flutterModuleProjects.map((project) => project.projectName).toList();

  if (projectNames.isEmpty) {
    MyLogger.log(
      'Nenhum projeto encontrado, registre-os em lib/flutter_module_projects',
      color: ColorCodes.red,
    );
    return;
  }
  final Project selectedProject;

  if (projectNames.length == 1) {
    selectedProject = flutterModuleProjects.first;
  } else {
    final projectSelector = TerminalSelector(options: projectNames);

    final selectedProjectIndex = projectSelector.run();

    selectedProject = flutterModuleProjects[selectedProjectIndex];
  }

  if (selectedProject.iosPath == null) {
    _buildAndroidAAR(selectedProject);
    return;
  }

  MyLogger.log('Deseja buildar para qual plataforma?');

  final buildOption = ['android', 'ios', 'ambos'];

  final buildSelector = TerminalSelector(options: buildOption);

  final selectedBuildOptionIndex = buildSelector.run();

  switch (selectedBuildOptionIndex) {
    case 0:
      await _buildAndroidAAR(selectedProject);
      break;
    case 1:
      await _buildIOSArtefacts(selectedProject);
      break;
    case 2:
      await Future.wait([
        _buildAndroidAAR(selectedProject),
        _buildIOSArtefacts(selectedProject),
      ]);
      break;
  }

  MyLogger.log('The little ice cream is ready :)', color: ColorCodes.green);
}

Future<void> _buildAndroidAAR(Project project) async {
  // Build Android Flutter Module
  MyLogger.log('Building Flutter Android aar', color: ColorCodes.yellow);

  final process = await Process.start(
    'flutter',
    ['build', 'aar'],
    runInShell: Platform.isWindows,
    workingDirectory: project.flutterPath,
  );

  // Read the standard output of the process
  final stdoutStream = process.stdout.transform(utf8.decoder);
  stdoutStream.listen((data) {
    print(data);
  });

  final exitCode = await process.exitCode;

  if (exitCode == 0) {
    MyLogger.log('Build successful!', color: ColorCodes.green);
  } else {
    MyLogger.log('Build failed!', color: ColorCodes.red);
  }

  // Move Android Flutter Module to Android project
  MyLogger.log('Deleted Flutter Android aar in Android Project', color: ColorCodes.yellow);

  TerminalCommand.deleteFile('${project.androidPath}/flutter/repo');

  MyLogger.log('Moving Flutter Android aar to Android Project', color: ColorCodes.yellow);

  TerminalCommand.movieFile(
    initialPath: '${project.flutterPath}/build/host/outputs/repo',
    destinationPath: '${project.androidPath}/flutter/repo',
  );

  MyLogger.log('Finish Android part', color: ColorCodes.green);
}

Future<void> _buildIOSArtefacts(Project project) async {
  // Build Android Flutter Module
  MyLogger.log('Building IOS Artefacts', color: ColorCodes.yellow);

  final process = await Process.start(
    'flutter',
    ['build', 'ios-framework', '--output=./artefacts/ios'],
    workingDirectory: project.flutterPath,
  );

  // Read the standard output of the process
  final stdoutStream = process.stdout.transform(utf8.decoder);
  stdoutStream.listen((data) {
    print(data);
  });

  final exitCode = await process.exitCode;

  if (exitCode == 0) {
    MyLogger.log('Build successful!', color: ColorCodes.green);
  } else {
    MyLogger.log('Build failed!', color: ColorCodes.red);
  }

  // Move Android Flutter Module to Android project
  MyLogger.log('Deleted Flutter Artefacts in IOS Project', color: ColorCodes.yellow);
  Process.runSync('rm', ['-r', '${project.iosPath}/flutter/Debug']);
  Process.runSync('rm', ['-r', '${project.iosPath}/flutter/Profile']);
  Process.runSync('rm', ['-r', '${project.iosPath}/flutter/Release']);
  MyLogger.log('Moving Flutter IOS artefacts to IOS Project', color: ColorCodes.yellow);
  Process.runSync('mv', [
    '${project.flutterPath}/artefacts/ios/Debug',
    '${project.iosPath}/flutter',
  ]);
  Process.runSync('mv', [
    '${project.flutterPath}/artefacts/ios/Profile',
    '${project.iosPath}/flutter',
  ]);
  Process.runSync('mv', [
    '${project.flutterPath}/artefacts/ios/Release',
    '${project.iosPath}/flutter',
  ]);

  MyLogger.log('Finish IOS part', color: ColorCodes.green);
}
