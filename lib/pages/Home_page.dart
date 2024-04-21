import 'package:Megaplayer/models/song.dart';
import 'package:Megaplayer/pages/song_page.dart';
import 'package:flutter/material.dart';
import 'package:Megaplayer/components/myDrawer.dart';
import 'package:Megaplayer/models/Playlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _homePageState();
}

class _homePageState extends State<HomePage>{
  //playlist provider
  late final dynamic playlistProvider;

  void initState(){
    super.initState();

    //get playlist provider
    playlistProvider=Provider.of<PlaylistProvider>(context,listen: false);


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
        MaterialPageRoute(builder: (context)=> const SongPage(),),);
  }

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