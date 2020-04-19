import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:music_player/screens/albumSongs.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/models/song.dart';
import 'package:palette_generator/palette_generator.dart';

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
      setState(() {
        widget.songList = TabView.songList;
      });
      if (widget.songList != null) createAlbums();
    }
    if (isChanged) createAlbums();
    return Container(
      child: widget.songList == null
          ? Image(
              image: AssetImage('img/placeholder.png'),
            )
          : GridView.builder(
              itemCount: widget.albums.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: size.aspectRatio * 1.65,
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 2 : 3),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridTile(
                      child: AlbumImage(
                        image: widget.albums[index].albumArt,
                        name: widget.albums[index].name,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AlbumSongs(widget.albums[index])));
                  },
                );
              },
            ),
    );
  }
}

class AlbumImage extends StatefulWidget {
  final String image;
  final String name;

  AlbumImage({Key key, this.image, this.name}) : super(key: key);

  @override
  _AlbumImageState createState() => _AlbumImageState();
}

class _AlbumImageState extends State<AlbumImage> {
  Color iconColor = Colors.black;

  void _updatePaletteGenerator(ImageProvider imageProvider) async {
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageProvider,
    );
    setState(() {
      iconColor = paletteGenerator.lightVibrantColor.color;
    });
  }

  ImageProvider imageProvider;

  @override
  void initState() {
    super.initState();
    imageProvider = widget.image != null
        ? FileImage(File(widget.image))
        : AssetImage('img/placeholder.png');

    _updatePaletteGenerator(imageProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 20,
                    color: Color(0xFF4056C6).withOpacity(.15),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.play_circle_outline,
                  size: 35,
                  color: iconColor,
                ),
              ),
            )
          ]),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '${widget.name}',
          style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.w800,
              fontFamily: 'BalooBhaina'),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ],
    );
  }
}
