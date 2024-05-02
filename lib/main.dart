import 'package:Megaplayer/models/Playlist_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Megaplayer/pages/Home_page.dart';
import 'package:Megaplayer/theme/light_mode.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/login_screen.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => PlaylistProvider())
    ],
      child: const MyApp(),
    ));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    logger.d("Debug message", error: {super.key});
    logger.w("Warning message!", error: {super.key});
    logger.e("Error message!!", error: {super.key});

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MegaPlayer',
      theme: theme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null) {
              return const HomePage(); // Usuario está logueado
            }
            return const LoginScreen(); // Usuario no está logueado
          }
          return const CircularProgressIndicator(); // Esperando conexión
        },
      ),

    );
  }
}






