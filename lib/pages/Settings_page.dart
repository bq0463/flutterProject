import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase/login_screen.dart';

class SettingsPage extends StatefulWidget{
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState()=>_SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, TextEditingController> controllers = {};

  Future<Map<String, dynamic>> _fetchAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final Map<String, dynamic> prefsMap = {};

    for (String key in keys) {
      prefsMap[key] = prefs.get(key);
      controllers[key] = TextEditingController(text: prefs.get(key).toString());
    }
    return prefsMap;
  }

  Future<void> _updatePreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:const Text("S e t t i n g s"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchAllPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            return Column(
                children:[
                  Expanded(
                  child: ListView(
                    children: snapshot.data!.entries.map((entry) {
                      return ListTile(title: Text(entry.key),
                        subtitle: TextField(
                        controller: controllers[entry.key],
                          decoration: InputDecoration(hintText: "Enter ${entry.key}"),
                        onSubmitted: (value) {
                          _updatePreference(entry.key, value);
                        },
                        ),
                      );
                    }).toList(),
                  ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showLogoutConfirmationDialog();
                      _signOut();
                    },
                    child: const Text('Logout'),
                  ),
                ],
            );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
    );
  }

  // Función para mostrar el diálogo de confirmación de logout
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Successful logout",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor:Colors.lightBlueAccent.shade100,
                  textColor: Colors.black87,
                  fontSize: 16.0,
                );
                _signOut();// Realiza el logout
              },
            ),
          ],
        );
      },
    );
  }
  // Función para hacer logout
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut(); // Hace logout

// Redirige a la pantalla de login
    // Redirige a la pantalla de inicio de la aplicación
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}