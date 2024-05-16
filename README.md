# Megaplayer 
# My flutter App for music

!!!!! Important,if you are gonna use git clone use git clone -b master https...     !!!!!!

Workspace

- Github
  
    -Repository: https://github.com/bq0463/flutterProject/tree/master
  
    -Release: https://github.com/bq0463/flutterProject/releases/tag/week15

Description

Manage the songs added in your mobile via assets with a realtime database system to manage your opinions about these songs.
 
Screenshots and Navigation

Home_page.dart before firebase auth:
![beforeAuth](https://github.com/bq0463/flutterProject/assets/158185157/931e7e5c-52af-4156-92f7-d1e1f0b36fb6)

Home_page.dart after firebase auth:

![after auth](https://github.com/bq0463/flutterProject/assets/158185157/3b7a3830-5ab9-4feb-b860-ef4b9444f170)

Home_Page.dart after setting shared prefs:
![after_shared_prefs](https://github.com/bq0463/flutterProject/assets/158185157/a8d05b22-ac92-494d-b255-54e24b919140)

song_page.dart:
![song_page](https://github.com/bq0463/flutterProject/assets/158185157/0ea29758-d247-45cf-8b62-ccb9d1526db1)

Adding fav:
![addFav](https://github.com/bq0463/flutterProject/assets/158185157/ce9ebb4a-d116-4658-bb48-5a884c87805f)

Add_Delete_FavSong.dart:
![Add_Delete_FavSong](https://github.com/bq0463/flutterProject/assets/158185157/8194709c-0f44-4d52-ab1f-a08d096fc1a3)

Demo Video

Video demonstrating how the app works

link:

Features

List the functional features of the app.

    -Now you can reproduce your favorite music in this app.
    -Interactive Drawer Menu.
    -Logout quick button in the settings menu.
    -Customized userId in shared preferences.
    -accelerometer feature to play the next or previous song when you move your phone to the left or right horizontally.
    
List the technical features of the app.

    -Firebase Real-time database saving your favorite songs.(Add_Delete_FavSong.dart)
    -sqflite service for the same purpose.(Add_Delete_FavSong.dart)
    -Add_Delete_FavSong.dart has a listTile of the sqflite songs.
    -accelerometer sensor.(song_page.dart)
    -Drawer menu used in the Home_page.dart.(myDrawer.dart component)
    -Every activity contains an arrow on the upper left side to move back to the Home_page.
    -Firebase authentication.(Home_page.dart and Settings_page.dart(logout button))
    -List of packages:
        -Playlist_provider.dart uses package:audioplayers.
        -Database_helper.dart uses package:sqflite to get songs from the initiated DB or insert them.
        -package:firebase_auth
        -package:provider is used in song_page to get data from the playlist_provider (such as the current song or the different durations and functions like playprevioussong or playnext) inside the Consumer.
        
