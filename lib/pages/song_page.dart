import 'package:Megaplayer/components/song_container.dart';
import 'package:Megaplayer/models/Playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

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
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //start time
                            Text("0:00"),

                            //shuffle icon
                            Icon(Icons.shuffle),

                            //repeat icon
                            Icon(Icons.repeat),

                            //end time
                            Text("0:00"),
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
                          max: 100,
                          value: 50,
                          activeColor: Colors.cyanAccent,
                          onChanged: (value) {},
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
                        onTap: () {},
                        child: const SongContainer(
                          child: Icon(Icons.skip_previous),
                        ),
                      )),

                      const SizedBox(width: 20),

                      //play pause
                      Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {},
                            child: const SongContainer(
                              child: Icon(Icons.play_arrow),
                            ),
                          )),
                      const SizedBox(width: 20),
                      //skip forward
                      Expanded(
                          child: GestureDetector(
                        onTap: () {},
                        child: const SongContainer(
                          child: Icon(Icons.skip_next),
                        ),
                      )),
                    ],
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
