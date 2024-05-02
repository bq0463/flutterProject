import 'dart:math';

import 'package:Megaplayer/components/song_container.dart';
import 'package:Megaplayer/models/Playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SongPage extends StatefulWidget {
  const SongPage({Key? key}) : super(key: key);

  @override
  _SongPageState createState() => _SongPageState();

}

class _SongPageState extends State<SongPage>{
  List<double> _accelerometerValues = [0, 0, 0];
  List<double> _gyroscopeValues = [0, 0, 0];
  //convert duration into min:seconds
  String formatTime(Duration duration){
    String twoDigitSeconds=duration.inSeconds.remainder(60).toString().padLeft(2,'0');
    String formattedTime="${duration.inMinutes}:$twoDigitSeconds";
    return formattedTime;
  }

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = [event.x, event.y, event.z];
      });
    });
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = [event.x, event.y, event.z];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        //get playlist
        final playlist = value.Playlist;
        //get index
        final currentSong = playlist[value.currentSongIndex ?? 0];
        //return UI
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
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
                        icon: const Icon(Icons.menu),
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
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
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

                  const SizedBox(height: 25),

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
                      const SizedBox(width: 20),
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
                  const SizedBox(width: 40),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Acelerómetro:  '),
                        Text('Eje X: ${_accelerometerValues[0].toStringAsFixed(2)}'),
                        SizedBox(width: 20),
                        Text('Eje Y: ${_accelerometerValues[1].toStringAsFixed(2)}'),
                        SizedBox(width: 20),
                        Text('Eje Z: ${_accelerometerValues[2].toStringAsFixed(2)}'),
                      ],
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Giroscopio:  '),
                        Text('Eje X: ${_gyroscopeValues[0].toStringAsFixed(2)}'),
                        SizedBox(width: 20),
                        Text('Eje Y: ${_gyroscopeValues[1].toStringAsFixed(2)}'),
                        SizedBox(width: 20),
                        Text('Eje Z: ${_gyroscopeValues[2].toStringAsFixed(2)}'),
                      ],
                    ),

                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
