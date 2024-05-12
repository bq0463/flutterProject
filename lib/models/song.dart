class Song {
  final String songName;
  final String artistName;
  final String albumArtImagePath;
  final String audioPath;
  final String note;
  final String comment;
  Song({
    required this.songName,
    required this.artistName,
    required this.albumArtImagePath,
    required this.audioPath,
    required this.note,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'songName': songName,
      'artistName': artistName,
      'albumArtImagePath': albumArtImagePath,
      'audioPath': audioPath,
      'note': note,
      'comment': comment};
  }
}