import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderServices {
  //url de base
  final String urlbase = "localhost:3000";
  final client = http.Client();

  //create
  Future<String> create(url, data, [auth]) async {
    try {
      var response = await client.post(Uri.http(urlbase, 'api/$url'),
          body: data, headers: {'authorization': auth ?? ""});
      if (response.statusCode == 400 || response.statusCode == 401) {
        throw Exception(json.decode(response.body)['data']);
      }
      return Future.value(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e);
    }
  }

  //find
  Future<Map<String,dynamic>> find(url, [auth]) async {
    try {
      var response = await client.get(Uri.http(urlbase, 'api/$url'),headers: {'authorization': auth ?? ""});
      if (response.statusCode == 400 || response.statusCode == 401) {
        throw Exception(response.body);
      }
      return Future.value(jsonDecode(response.body));
    } catch (e) {
      return Future.error(e);
    }
  }

  //find by
  Future<String> findBy(url, id, [auth]) async {
    try {
      var response = await client.get(Uri.http(urlbase, 'api/$url/$id'),
          headers: {'authorization': auth ?? ""});
      if (response.statusCode == 400 || response.statusCode == 401) {
        throw Exception(response.body);
      }
      return Future.value(response.body.toString());
    } catch (e) {
      return Future.error(e);
    }
  }

  //update
  Future<String> updateId(url, id, data, [auth]) async {
    try {
      var response = await client.put(Uri.http(urlbase, '/$url/$id'),
          body: data, headers: {'authorization': auth ?? ""});
      if (response.statusCode == 400 || response.statusCode == 401) {
        throw Exception(response.body);
      }
      return Future.value(response.body.toString());
    } catch (e) {
      return Future.error(e);
    }
  }

  //delete
  Future<String> deleteBy(url, id, [auth]) async {
    try {
      var response = await client.delete(Uri.http(urlbase, '/$url/$id'),
          headers: {'authorization': auth ?? ""});
      if (response.statusCode == 400 || response.statusCode == 401) {
        throw Exception(response.body);
      }
      return Future.value(response.body.toString());
    } catch (e) {
      return Future.error(e);
    }
  }
}

class SharedPreferencesStorage {
  Future<SharedPreferences> initShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  //add
  Future<void> createStorage(key, value) async {
    try {
      var storage = await initShared();
      storage.setString(key, value);
    } catch (e) {
      Future.error({"Error create SharedPreferences": e});
    }
  }

  //read
  Future<String> readStorage(key) async {
    var storage = await initShared();
    var value = storage.getString(key);
    return value.toString();
  }

  //update
  Future<void> deleteStorage(key) async {
    var storage = await initShared();
    storage.remove(key);
  }
}
