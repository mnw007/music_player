
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:music_player/screens/albumSongs.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/widgets/album-grid-item.dart';

import '../models/album.dart';

bool isChanged = false;

class Albums extends StatefulWidget {
  List<Song> songList;
  List<Album> albums = List();
  Albums();

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  void createAlbums() {
    isChanged = false;
    widget.albums
        .add(Album(widget.songList[0].album, widget.songList[0].albumArt));
    widget.albums[0].albumSongs(widget.songList[0]);
    int cnt;
    for (int i = 1; i < widget.songList.length; i++) {
      cnt = widget.albums.length;
      for (int j = 0; j < widget.albums.length; j++) {
        if (widget.albums[j].name == widget.songList[i].album) {
          widget.albums[j].album.add(widget.songList[i]);
          if (widget.albums[j].name != null)
            widget.albums[j].name = widget.songList[i].album;
          if (widget.albums[j].albumArt != null)
            widget.albums[j].albumArt = widget.songList[i].albumArt;
          cnt = 0;
          break;
        }
      }
      if (cnt != 0) {
        widget.albums
            .add(Album(widget.songList[i].album, widget.songList[i].albumArt));
        widget.albums[cnt].albumSongs(widget.songList[i]);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final size = MediaQuery.of(context).size;

    if (widget.songList == null) {
      setState(() => widget.songList = TabView.songList);
      if (widget.songList != null) createAlbums();
    }
    if (isChanged) createAlbums();
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: widget.songList == null
          ? Image(image: AssetImage(kPlaceholderPath),)
          : GridView.builder(
        padding: EdgeInsets.only(bottom: size.height * 0.15),
        itemCount: widget.albums.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: size.aspectRatio * 1.65,
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 2 : 3),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridTile(
                      child: AlbumItem(
                        image: widget.albums[index].albumArt,
                        name: widget.albums[index].name,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AlbumSongs(widget.albums[index]))
                    ),
                );
              },
            ),
    );
  }
}

