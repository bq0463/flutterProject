import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget{
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:const Text("S e t t i n g s"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}