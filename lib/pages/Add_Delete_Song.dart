import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/song.dart';

class AddSongForm extends StatefulWidget {


  const AddSongForm({super.key});

  @override
  _AddSongFormState createState() => _AddSongFormState();
}

class _AddSongFormState extends State<AddSongForm> {
  final _songNameController = TextEditingController();
  final _artistNameController = TextEditingController();
  final _songPathController = TextEditingController();
  final _songImageController=TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Crear una instancia de la canción con los datos ingresados por el usuario
      Song newSong = Song(
        songName: _songNameController.text,
        artistName: _artistNameController.text,
        albumArtImagePath: _songImageController.text, // Puedes agregar un campo para la imagen del álbum si lo deseas
        audioPath: _songPathController.text,
      );

      // Abrir la base de datos
      final database = openDatabase(
        join(await getDatabasesPath(), 'songs_database.db'),
        onCreate: (db, version) {
          // Crear la tabla si no existe
          return db.execute(
            'CREATE TABLE songs(id INTEGER PRIMARY KEY, songName TEXT, artistName TEXT, albumArtImagePath TEXT, audioPath TEXT)',
          );
        },
        version: 1,
      );

      // Insertar la canción en la base de datos
      await database.then((db) {
        return db.insert(
          'songs',
          newSong.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });

      // Limpiar los controladores de texto después de agregar la canción
      _songNameController.clear();
      _artistNameController.clear();
      _songPathController.clear();

      // Mostrar un mensaje de éxito al usuario
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('The song has added correctly')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _songNameController,
            decoration: const InputDecoration(labelText: 'Song´s name'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'put the name´s song';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _artistNameController,
            decoration: const InputDecoration(labelText: 'artist´s name'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'put the artist´s song';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _songPathController,
            decoration: const InputDecoration(labelText: 'Route´s song'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Put the path of the song';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _songImageController,
            decoration: const InputDecoration(labelText: 'image route'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Put the image of the song';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Add Song'),
          ),
        ],
      ),
    );
  }
}
