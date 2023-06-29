class Project {
  String? iosPath;
  String projectName;
  String androidPath;
  String flutterPath;

  Project({
    required this.androidPath,
    required this.flutterPath,
    required this.projectName,
    this.iosPath,
  });
}
