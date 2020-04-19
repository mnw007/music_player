import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/screens/play.dart';
import 'package:music_player/utils/player.dart';
import 'package:music_player/screens/playlist.dart';
import 'dart:convert';
import '../models/song.dart';

_SongsState stateSong; //added

class Songs extends StatefulWidget {
  List<Song> songList;

  Songs();

  static int indexSelected;

  @override
  _SongsState createState() => stateSong = _SongsState();
}

class _SongsState extends State<Songs> {
  static const platform = const MethodChannel('music_player/songsUri');
  MyPlayer player = MyPlayer();
  List<Song> addList = List();

  void _getSongs() async {
    PlatformException exception;
    String _songsList;
    try {
      final String result = await platform.invokeMethod('getSongs');
      _songsList = result;
    } on PlatformException catch (e) {
      exception = e;
      print(e);
    }
    if (exception == null) {
      List userSongs = json.decode(_songsList);
      List<Song> list = userSongs.map(Song.fromJson).toList();
      setState(() {
        widget.songList = list;
        TabView.songList = widget.songList;
        playlist;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.songList == null) {
      _getSongs();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.songList==null)
      widget.songList=TabView.songList;

    return Container(
        child: widget.songList == null
            ? Image(
                image: AssetImage('img/placeholder.png'),
              )
            : ListView.builder(
                itemCount: widget.songList.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Songs.indexSelected == index ||
                            widget.songList[index].isSelected
                        ? Colors.brown[400]
                        : Theme.of(context).scaffoldBackgroundColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: widget.songList[index].albumArt != null
                            ? FileImage(File(widget.songList[index].albumArt))
                            : AssetImage('img/placeholder.png'),
                      ),
                      title: Text(
                        '${widget.songList[index].title}',
                        style: TextStyle(
                            color: Songs.indexSelected == index ||
                                    widget.songList[index].isSelected
                                ? (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.white)
                                : (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black)),
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                      ),
                      trailing: Text('${widget.songList[index].duration}',
                          style: TextStyle(
                              color: Songs.indexSelected == index ||
                                      widget.songList[index].isSelected
                                  ? (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : Colors.white)
                                  : (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black))),
                      subtitle: Text('${widget.songList[index].artist}',
                          style: TextStyle(
                              color: Songs.indexSelected == index ||
                                      widget.songList[index].isSelected
                                  ? (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : Colors.white70)
                                  : (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white70
                                      : Colors.black))),
                      onTap: () {
                        setState(() {
                          if (!anySelected)
                            Songs.indexSelected = index;
                          else {
                            widget.songList[index].isSelected =
                                !widget.songList[index].isSelected;
                            if (Songs.indexSelected == index)
                              Songs.indexSelected = null;
                            widget.songList[index].isSelected
                                ? addList.add(widget.songList[index])
                                : addList.remove(widget.songList[index]);
                          }
                        });
                        if (!anySelected) {
                          isAlbum=false;
                          player.playMusic(widget.songList[index]);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Play(widget.songList,
                                      widget.songList[index], index)));
                        }
                        if (addList.isEmpty) {
                          anySelected = false;
                          tabState.setState(() => anySelected);
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          anySelected = true;
                          widget.songList[index].isSelected = true;
                          addList.add(widget.songList[index]);
                          Songs.indexSelected = index;
                        });
                        tabState.setState(() => anySelected);
                      },
                    ),
                  );
                }));
  }
}
