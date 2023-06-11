import 'package:shared_preferences/shared_preferences.dart';

import '../../models/example_model.dart';

class MySharedPref {
  static const String keyValue = "value";
  static const String keyExampleModel = "exampleModel";

  Future<SharedPreferences> getPreferences() async =>
      await SharedPreferences.getInstance();

  setValue(String value) async {
    (await getPreferences()).setString(keyValue, value);
  }

  Future<String?> getValue() async =>
      (await getPreferences()).getString(keyValue);

  setModel(ExampleModel model) async {
    (await getPreferences())
        .setString(keyExampleModel, exampleModelToJson(model));
  }

  Future<ExampleModel?> getModel() async {
    var data = (await getPreferences()).getString(keyExampleModel);
    if (data != null) return exampleModelFromJson(data);
    return null;
  }

  Future<bool> clearAllData() async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove(keyValue);
    sharedPref.remove(keyExampleModel);
    return true;
  }
}
