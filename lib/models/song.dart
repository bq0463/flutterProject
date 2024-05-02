class Song {
  final String songName;
  final String artistName;
  final String albumArtImagePath;
  final String audioPath;

  Song({
    required this.songName,
    required this.artistName,
    required this.albumArtImagePath,
    required this.audioPath});

  Map<String, dynamic> toMap() {
    return {
      'songName': songName,
      'artistName': artistName,
      'albumArtImagePath': albumArtImagePath,
      'audioPath': audioPath,
    };
  }
}