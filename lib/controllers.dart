import 'package:get/get.dart';
import 'package:taskmobile/models.dart';
import 'package:taskmobile/services.dart';

class ControllerTask extends GetxController with StateMixin<List<Task>> {
  ProviderServices providerServices = ProviderServices();
  SharedPreferencesStorage sharedPreferencesStorage =
      SharedPreferencesStorage();

  @override
  void onReady() {
    fetchList();
    super.onReady();
  }

  

  fetchList() async {
    try {
      var auth = await sharedPreferencesStorage.readStorage("auth");
      var response = await providerServices.find("task/find/all", auth);
      var data = listFromJson(response['data']);
      print(data);
      change(data, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}

class ControllerUser extends GetxController {
  ProviderServices providerServices = ProviderServices();
  SharedPreferencesStorage sharedPreferencesStorage =
      SharedPreferencesStorage();
  //login
  Future<String> loginApplication(String email, String password) async {
    try {
      Map<String, dynamic> data = {"password": password, "email": email};
      var response = await providerServices.create('users/login', data, "sss");
      await sharedPreferencesStorage.createStorage("auth", response.toString());
      print(await sharedPreferencesStorage.readStorage("auth"));
      return Future.value("Hello");
    } catch (e) {
      return Future.error(e);
    }
  }

  //login
  Future<String> siginApplication(
      String email, String password, String name, String lastname) async {
    try {
      Map<String, dynamic> data = {
        "password": password,
        "email": email,
        "name": name,
        "lastname": lastname,
        "avatar": "x"
      };
      var response = await providerServices.create('users/signup', data);
      return Future.value("Hello");
    } catch (e) {
      return Future.error(e);
    }
  }
}
