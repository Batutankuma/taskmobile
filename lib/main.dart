import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmobile/controllers.dart';
import 'package:taskmobile/models.dart';
import 'package:taskmobile/services.dart';

void main() async {
  SharedPreferencesStorage sharedPreferencesStorage =
      SharedPreferencesStorage();
  var prefs = await sharedPreferencesStorage.initShared();
  runApp(MyApp(sharedPreferencesStorage: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferencesStorage;
  const MyApp({super.key, required this.sharedPreferencesStorage});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: sharedPreferencesStorage.get("auth") != null
          ? HomePage()
          : LoginPage(), // const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
//login

class LoginPage extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final ControllerUser controllerUser = Get.put(ControllerUser());
  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    String message = "";
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                controller: password,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 15),
              Text(message),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await controllerUser.loginApplication(
                        email.text, password.text);
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: ((context) => HomePage())),
                        (route) => false);
                  } catch (e) {
                    final snackBar = SnackBar(
                      content: Text("$e"),
                      action: SnackBarAction(
                        label: "Ok",
                        // ignore: avoid_returning_null_for_void
                        onPressed: () => null,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Center(child: Text("CONNEXION")),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                child: const Center(
                  child: Text("Add Compte"),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => SignPage()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignPage extends StatelessWidget {
  final TextEditingController name = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final ControllerUser controllerUser = Get.put(ControllerUser());
  final _formKey = GlobalKey<FormState>();

  SignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: lastname,
                decoration: const InputDecoration(labelText: "Lastname"),
              ),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                controller: password,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await controllerUser.siginApplication(
                        email.text, password.text, name.text, lastname.text);
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: ((context) => HomePage())),
                        (route) => false);
                  } catch (e) {
                    final snackBar = SnackBar(content: Text("$e"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Center(child: Text("SINGIN")),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});
  ControllerTask controllerTask = Get.put(ControllerTask());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferencesStorage sharedPreferencesStorage =
                    SharedPreferencesStorage();
                await sharedPreferencesStorage.deleteStorage("auth");
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: ((context) => LoginPage())),
                    (route) => false);
              },
              icon: const Icon(Icons.outlet))
        ],
      ),
      body: controllerTask.obx((state) {
        if (state!.isNotEmpty) {
          return ListView.builder(
            itemCount: state.length,
            itemBuilder: (context, index) => listTile(state[index]),
          );
        } else {
          return const Center(
            child: Text("Veuillez ajouter vos tâche c'est encore vide"),
          );
        }
      }, onError: ((error) {
        return Center(
          child: Text("$error"),
        );
      }),
          onLoading: const Center(
            child: CircularProgressIndicator(),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          SharedPreferencesStorage sharedPreferencesStorage =
              SharedPreferencesStorage();
          print(await sharedPreferencesStorage.readStorage("auth"));
        },
        child: const Center(
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  ListTile listTile(Task task) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
    );
  }
}
