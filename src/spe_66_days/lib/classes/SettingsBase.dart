import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class SettingsBase<T> {
  final String saveFileName;

  T settings;

  SettingsBase(this.saveFileName, this.settings);

  String getJson(){
    return json.encode(settings);
  }

  T getSettingsFromJson(Map<String, dynamic> json){
    return null;
  }

  Future<File> save() async {
    print("Saving $saveFileName...");
    final file = await _localFile;
    String output = json.encode(settings);
    return file.writeAsString(output);
  }

  Future<File> load() async {
    try {
      print("Loading $saveFileName...");
      File localFile = await _localFile;

      if (!(await localFile.exists()))
        throw("file doesn't exist fam");

      return localFile.readAsString().then((contents) {
        this.settings = getSettingsFromJson(json.decode(contents));
      });
    } catch (e) {
      // If we encounter an error, return 0
      return save();
    }
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$saveFileName');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

}