import 'package:audioplayers/audioplayers.dart';
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

  //AUDIOPLAYER section

  //audio player
  final AudioPlayer _audioPlayer=AudioPlayer();
  //durations
  Duration _currentDuration=Duration.zero;
  Duration _totalDuration=Duration.zero;

  //constructor
  PlaylistProvider (){
    listenToDuration();
  }

  //initially not playing
  bool _isPlaying = false;

  //play the song
  void play() async{
    final String path=_playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); //stop current song
    await _audioPlayer.play(AssetSource(path)); //play the new song
    _isPlaying=true;
    notifyListeners();
  }

  //pause current song
  void pause() async{
    await _audioPlayer.pause();
    _isPlaying=false;
    notifyListeners();
  }

  //resume

  void resume() async{
    await _audioPlayer.resume();
    _isPlaying=true;
    notifyListeners();
  }
  //pause or resume
  void pauseOrResume() async{
    if(_isPlaying){
      pause();
    }else{
      resume();
    }
    notifyListeners();
  }
  //seek to a specific position in the current song
  void seek(Duration position) async{
    await _audioPlayer.seek(position);
  }
  //play next
  void playNextSong(){
    if(_currentSongIndex != null){
      if(_currentSongIndex! < _playlist.length-1){
        //go next if its not the last song
        currentSongIndex=_currentSongIndex! + 1;
      }else{
        //back to the first song
        currentSongIndex=0;
      }
    }
  }
  //play previous
  void playPreviousSong() async{
    //restart the  song at the start if 2 seconds have passed
    if(_currentDuration.inSeconds > 2){
      seek(Duration.zero);
    }else{
      if(_currentSongIndex! >0){
        currentSongIndex=_currentSongIndex! - 1;
      }else{
        //
        currentSongIndex = _playlist.length -1;
      }
    }
  }
  //listen to duration
  void listenToDuration(){
    //listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
        _totalDuration=newDuration;
        notifyListeners();
    });

    //listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration=newPosition;
      notifyListeners();
    });


    //listen for song completed
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  //dispose audioplayer

  //GET playlist,index
  List<Song> get Playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying =>_isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  //SET playlist,index

  set currentSongIndex(int? index){
    //index
    _currentSongIndex=index;

    if(index != null){
      play(); //play the song at the new index
    }
    //UI update
    notifyListeners();
  }
}