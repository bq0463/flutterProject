import 'package:Megaplayer/models/Playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:Megaplayer/pages/Home_page.dart';
import 'package:Megaplayer/theme/light_mode.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

void main() {
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
    logger.d("Debug message", {super.key});
    logger.w("Warning message!", {super.key});
    logger.e("Error message!!", {super.key});

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MegaPlayer',
      theme: theme,
      home: const HomePage(

      ),

    );
  }
}






