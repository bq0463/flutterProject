import 'package:flutter/cupertino.dart';
import 'package:Megaplayer/models/song.dart';
class PlaylistProvider extends ChangeNotifier{
  //playlist of songs
  final List<Song> _playlist=[
      Song(songName: "bury the light",
          artistName: "Victor Borba",
          albumArtImagePath: "assets/images/burythelight.jpg",
          audioPath: "audio/burythelight.mp3"),
      Song(songName: "Radioactive",
          artistName: "Imagine Dragons",
          albumArtImagePath: "assets/images/Imagine_Dragons.jpg",
          audioPath: "audio/radioactive.mp3")
  ];

  int? _currentSongIndex;


  //GET playlist,index
  List<Song> get Playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;

  //SET playlist,index

  set currentSongIndex(int? index){
    //index
    _currentSongIndex=index;
    //UI update
    notifyListeners();
  }
}