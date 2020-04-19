import 'song.dart';

class Album {
  List<Song> album = List();
  String name;
  String albumArt;

  Album(this.name, this.albumArt);
  Album.fromPlaylist(this.name);

  get songs => this.album;
  void albumSongs(Song song) => this.album.add(song);
  void addAlbum(List<Song> album) => this.album.addAll(album);
}