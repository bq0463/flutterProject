import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Megaplayer/db/database_helper.dart';
import 'package:Megaplayer/models/song.dart';

class AddSongFav extends StatefulWidget {
  const AddSongFav({Key? key}) : super(key: key);

  @override
  _AddSongFavState createState() => _AddSongFavState();
}

class _AddSongFavState extends State<AddSongFav> {
  late Future<List<Song>> _songsFuture;

  @override
  void initState() {
    super.initState();
    _songsFuture = DatabaseHelper().getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Theme.of(context).colorScheme.inversePrimary,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    //title
                    const Text("F a v o r i t e s"),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // User favorite list
              Expanded(
                child: FutureBuilder<List<Song>>(
                  future: _songsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      List<Widget> favoriteWidgets = [];
                      List<Song>? songs = snapshot.data;
                      if (songs != null) {
                        songs.forEach((song) {
                          // Agregar cada canción favorita como un ListTile
                          favoriteWidgets.add(
                            Container(
                              color: Theme.of(context).colorScheme.inversePrimary,
                              child: ListTile(
                                title: Text(song.songName),
                                subtitle: Text(song.comment),
                              ),
                            ),
                          );
                        });
                      }
                      return ListView(
                        children: favoriteWidgets,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
