import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/widgets/drawer.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/utils/localizations.dart';
import 'package:music_player/screens/play.dart';
import 'package:music_player/utils/player.dart';
import 'package:music_player/screens/playlist.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/widgets/settings.dart';
import 'package:music_player/widgets/song-bar.dart';
import 'package:music_player/widgets/songs.dart';

import '../models/album.dart';

_AlbumSongsState albumState;
List<Song> playingList;

class AlbumSongs extends StatefulWidget {
  final Album songs;
  bool isPlaylist;
  AlbumSongs(this.songs, {this.isPlaylist = false});
  static int indexSelected;

  @override
  _AlbumSongsState createState() => albumState = _AlbumSongsState();
}

class _AlbumSongsState extends State<AlbumSongs> {
  bool isSelected = false;
  MyPlayer mPlayer = MyPlayer();
  List<Song> addList = List();

  void delete() {
    for (int i = 0; i < widget.songs.album.length;) {
      if (widget.songs.album[i].isSelected) {
        widget.songs.album.remove(widget.songs.album[i]);
        i = 0;
      } else
        i++;
    }
    editFile();
    setState(() {
      widget.songs.album;
      isSelected = false;
      AlbumSongs.indexSelected = null;
    });
  }

  @override
  void initState() {
    super.initState();
    AlbumSongs.indexSelected = null;
  }

  void selectAll() {
    widget.songs.album.forEach((song) => song.isSelected = true);
    setState(() => widget.songs.album);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: SettingsButton(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: !isSearch
            ? Text(
                '${widget.songs.name}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                maxLines: 1,
              )
            : Container(
                child: TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: '     ${MyLocalizations.of(context).search}',
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    onSubmitted: (_) => search(context)),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
              ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: IconButton(
              icon: isSearch ? Icon(Icons.clear) : Icon(Icons.search),
              onPressed: () => setState(() {
                isSearch = !isSearch;
                controller.text = '';
              }),
            ),
          ),
          !isSelected
              ? Container()
              : IconButton(icon: Icon(Icons.select_all), onPressed: selectAll),
          !isSelected
              ? Container()
              : IconButton(icon: Icon(Icons.delete), onPressed: delete),
        ],
      ),
      body: Stack(children: <Widget>[
        SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(bottom: height * .05, top: height * 0.04),
                  child: Container(
                    height: height * 0.3,
                    width: width * .6,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 20,
                          color: Color(0xFF757575).withOpacity(.25),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        image: widget.songs.album[0].albumArt != null
                            ? FileImage(File(widget.songs.album[0].albumArt))
                            : AssetImage(kPlaceholderPath),
                        fit: BoxFit.fill,
                        width: width * 0.6,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: height * 0.5,
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: height * 0.15),
                      itemCount: widget.songs.album.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            color: AlbumSongs.indexSelected == index ||
                                    widget.songs.album[index].isSelected
                                ? Colors.brown[400]
                                : Theme.of(context).scaffoldBackgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 8, bottom: 8, right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 10),
                                          blurRadius: 20,
                                          color: Color(0xFF757575)
                                              .withOpacity(.15),
                                        )
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image(
                                        image: widget.songs.album[index]
                                                    .albumArt !=
                                                null
                                            ? FileImage(File(widget
                                                .songs.album[index].albumArt))
                                            : AssetImage(kPlaceholderPath),
                                        fit: BoxFit.fill,
                                        height: height * 0.095,
                                        width: width * 0.18,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${widget.songs.album[index].title}',
                                            style: TextStyle(
                                                fontFamily: kBalooBhainaFont,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AlbumSongs
                                                                .indexSelected ==
                                                            index ||
                                                        widget
                                                            .songs
                                                            .album[index]
                                                            .isSelected
                                                    ? (Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.black
                                                        : Colors.white)
                                                    : (Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black)),
                                            maxLines: 1,
                                          ),
                                          Text(
                                            '${widget.songs.album[index].artist}',
                                            style: TextStyle(
                                                fontFamily: kBalooBhainaFont,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: AlbumSongs
                                                                .indexSelected ==
                                                            index ||
                                                        widget
                                                            .songs
                                                            .album[index]
                                                            .isSelected
                                                    ? (Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.grey
                                                        : Colors.white70)
                                                    : (Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white70
                                                        : Colors.grey)),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text('${widget.songs.album[index].duration}',
                                      style: TextStyle(
                                          fontFamily: kBalooBhainaFont,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: AlbumSongs.indexSelected ==
                                                      index ||
                                                  widget.songs.album[index]
                                                      .isSelected
                                              ? (Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey
                                                  : Colors.white)
                                              : (Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.grey))),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (!isSelected)
                                AlbumSongs.indexSelected = index;
                              else {
                                widget.songs.album[index].isSelected =
                                    !widget.songs.album[index].isSelected;
                                if (AlbumSongs.indexSelected == index)
                                  AlbumSongs.indexSelected = null;
                                widget.songs.album[index].isSelected
                                    ? addList.add(widget.songs.album[index])
                                    : addList.remove(widget.songs.album[index]);
                              }
                            });
                            Songs.indexSelected = null;
                            if (!isSelected) {
                              playingList = widget.songs.album;
                              isAlbum = true;
                              mPlayer.playMusic(widget.songs.album[index]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Play(
                                          widget.songs.album,
                                          widget.songs.album[index],
                                          index)));
                            }
                            if (addList.isEmpty)
                              setState(() => isSelected = false);
                          },
                          onLongPress: () {
                            if (widget.isPlaylist) {
                              setState(() {
                                widget.songs.album[index].isSelected = true;
                                addList.add(widget.songs.album[index]);
                                AlbumSongs.indexSelected = index;
                                isSelected = true;
                              });
                            }
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: player != null ? SongBar() : null),
      ]),
    );
  }
}
