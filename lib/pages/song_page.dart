
import 'dart:async';

import 'package:Megaplayer/components/song_container.dart';
import 'package:Megaplayer/models/Playlist_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';
import '../models/song.dart';
class SongPage extends StatefulWidget {
  const SongPage({Key? key}) : super(key: key);

  @override
  _SongPageState createState() => _SongPageState();

}

class _SongPageState extends State<SongPage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String uid;
  List<double> _accelerometerValues = [0, 0, 0];
  //convert duration into min:seconds
  String formatTime(Duration duration){
    String twoDigitSeconds=duration.inSeconds.remainder(60).toString().padLeft(2,'0');
    String formattedTime="${duration.inMinutes}:$twoDigitSeconds";
    return formattedTime;
  }

  StreamSubscription? _accelerometerSubscription; // Declarar la suscripción

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = [event.x, event.y, event.z];
      });
    });
    _loadPrefs();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel(); // Cancelar la suscripción en dispose()
    super.dispose();
  }
  Color _iconColor = Colors.black; // Initial color
  void _changeColor(){
    setState(() {
      _iconColor = Theme.of(context).colorScheme.inversePrimary; // Change color here
    });
  }
  Future<String?> _loadPrefs() async{
    final prefs =await SharedPreferences.getInstance();
    String? uidi=prefs.getString('uid');
    String? token =prefs.getString('token');
    if(uidi!=null) {
      uid=uidi;
    } else{
      uid="Stranger";
    }
  }
  void showAddFavoriteDialog(BuildContext context, Function(String, String) onAddFavorite) {
    final TextEditingController commentController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add to Favorites'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: 'Comment'),
              ),
              TextField(
                controller: noteController,
                decoration: InputDecoration(labelText: 'Note'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String comment = commentController.text;
                String note = noteController.text;
                onAddFavorite(comment, note);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    // Insert function in firebase
    void _toggleFavorite(String songname,String artistName,) {
      showAddFavoriteDialog(context, (String comment, String note) {
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        String songId = songname.hashCode.toString();

        DatabaseReference userFavoritesRef = FirebaseDatabase.instance
            .reference()
            .child('favorites')
            .child(userId!)
            .child('favorites')
            .child(songId);

        userFavoritesRef.once().then((event) {
          DataSnapshot snapshot = event.snapshot;
          if (snapshot.value != null) {
            // Song is on fav
            userFavoritesRef.remove();
          } else {
            // Song is not  on fav, add
            userFavoritesRef.set({
              'artist': artistName,
              'comment': comment,
              'note': note,
              'title': songname,
            });
          }
        });
        // Insert song in SQLite db
        Song song = Song(
          songName: songname,
          artistName: artistName,
          albumArtImagePath: 'path/to/albumArt.jpg',
          audioPath: 'path/to/audio.mp3',
          note: note,
          comment: comment,
        );
        DatabaseHelper().insertSong(song);
      });
    }

    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        //get playlist
        final playlist = value.Playlist;
        //get index
        final currentSong = playlist[value.currentSongIndex ?? 0];

        if(_accelerometerValues[0]>= 5){ //if you turn the mobile to the left plays the next one
          value.playNextSong();
        }else{
          if (_accelerometerValues[0] <= -5) { //if you turn the mobile to the left plays the previous one
            value.playPreviousSong();
          }
        }
        //return UI
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),

                      //title
                      const Text("P L A Y L I S T"),
                      //menu button
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.account_box),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                  //album artwork

                  SongContainer(
                    child: Column(
                      children: [
                        //image
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(currentSong.albumArtImagePath)),
                        //song ,artist
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //artist name and song
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(currentSong.artistName),
                                ],
                              ),

                              //icon fav
                              Expanded(
                                child: GestureDetector(
                                  child: Icon(
                                      Icons.favorite,
                                      color: _iconColor),
                                  onTap: () {
                                    _toggleFavorite(currentSong.songName,currentSong.artistName);
                                    _changeColor();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  //song progress
                  Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 25.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //start time
                            Text(formatTime(value.currentDuration)),

                            //shuffle icon
                            const Icon(Icons.shuffle),

                            //repeat icon
                            const Icon(Icons.repeat),

                            //end time
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),
                      ),

                      //song duration progress
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 0),
                        ),
                        child: Slider(
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble(),
                          value: value.currentDuration.inSeconds.toDouble(),
                          activeColor: Colors.cyanAccent,
                          label: "${value.currentDuration.inSeconds.toDouble()}",
                          onChanged: (double double) {
                            //user sliding around
                            value.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  //playback controls
                  Row(
                    children: [
                      //skip previous
                      Expanded(
                          child: GestureDetector(
                            onTap: value.playPreviousSong,
                            child: const SongContainer(
                              child: Icon(Icons.skip_previous),
                            ),
                          ),
                      ),

                      const SizedBox(width: 20),

                      //play pause
                      Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: value.pauseOrResume,
                            child:  SongContainer(
                              child: Icon(value.isPlaying ? Icons.pause: Icons.play_arrow),
                            ),
                          ),
                      ),
                      const SizedBox(width: 10),
                      //skip forward
                      Expanded(
                          child: GestureDetector(
                            onTap: value.playNextSong,
                            child: const SongContainer(
                              child: Icon(Icons.skip_next),
                        ),
                      ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 5.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('SpeedMeter:  '),
                        Text('Axys X: ${_accelerometerValues[0].toStringAsFixed(2)}'),
                        SizedBox(width: 20),
                        Text('Axys Y: ${_accelerometerValues[1].toStringAsFixed(2)}'),
                        SizedBox(width: 20),
                        Text('Axys Z: ${_accelerometerValues[2].toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Text("Welcome back, "),
                ],
              ),
            ),
            ),
          ),
        );
      },
    );
  }
}
