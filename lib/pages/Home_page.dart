import 'dart:async';

import 'package:Megaplayer/models/song.dart';
import 'package:Megaplayer/pages/song_page.dart';
import 'package:flutter/material.dart';
import 'package:Megaplayer/components/myDrawer.dart';
import 'package:Megaplayer/models/Playlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../db/database_helper.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _homePageState();
}

class _homePageState extends State<HomePage>{
  StreamSubscription<Song>? _songStreamSubscription;
  DatabaseHelper db = DatabaseHelper();
  //playlist provider
  late final dynamic playlistProvider;
  final logger = Logger();
  final _uidController = TextEditingController();
  final _tokenController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _loadPrefs();
    //get playlist provider
    playlistProvider=Provider.of<PlaylistProvider>(context,listen: false);
  }

  Future<void> _loadPrefs() async{
    final prefs =await SharedPreferences.getInstance();
    String? uid=prefs.getString('uid');
    String? token =prefs.getString('token');

    if (uid == null || token == null){
      _showInputDialog();
    }else{
      logger.d("UID: $uid ,token: $token");
    }
  }

  void goToSong(BuildContext context,int songIndex,String songName){
    Fluttertoast.showToast(
      msg: "Now Playing : $songName",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:Colors.lightBlueAccent.shade100,
      textColor: Colors.black87,
      fontSize: 16.0,
    );

    //update index
    playlistProvider.currentSongIndex=songIndex;

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> const SongPage(),),
    );
  }

  Future<void> _showInputDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter UID and Token'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _uidController,
                  decoration: const InputDecoration(hintText: "UID"),
                ),
                TextField(
                  controller: _tokenController,
                  decoration: const InputDecoration(hintText: "Token"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('uid', _uidController.text);
                await prefs.setString('token', _tokenController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("M e g a  P l a y e r"),
                    centerTitle: true,
                    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder:(context,value,child) {
            //playlist
            final List<Song> playlist= value.Playlist;
            return ListView.builder(
                //song
                itemCount:playlist.length,
                itemBuilder: (context,index){
                  //get song
                  final Song song=playlist[index];
                  //return UI list
                  return ListTile(
                    title: Text(song.songName),
                    subtitle: Text(song.artistName),
                    leading: Image.asset(song.albumArtImagePath),
                    onTap: () => goToSong(context,index,song.songName),
                  );
                },
            );
        }
      ),
    );
  }

}