import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/screens/play.dart';
import 'package:music_player/utils/constants.dart';
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
  static const platform = const MethodChannel(kMethodChannel);
  MyPlayer player = MyPlayer();
  List<Song> addList = List();

  void _getSongs() async {
    PlatformException exception;
    String _songsList;
    try {
      final String result = await platform.invokeMethod(kGetSongs);
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
    if (widget.songList == null) widget.songList = TabView.songList;
    Size size = MediaQuery.of(context).size;

    return Container(
      child: widget.songList == null
          ? Image(
              image: AssetImage(kPlaceholderPath),
            )
          : ListView.builder(
          padding: EdgeInsets.only(bottom: size.height * 0.15),
          itemCount: widget.songList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
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
                        isAlbum = false;
                        player.playMusic(widget.songList[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Play(
                                widget.songList, widget.songList[index], index),
                          ),
                        );
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
                  child: Container(
                    color: Songs.indexSelected == index ||
                            widget.songList[index].isSelected
                        ? Colors.brown[400]
                        : Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left:10.0, top:8, bottom: 8, right: 10),
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
                                color: Color(0xFF757575).withOpacity(.15),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image: widget.songList[index].albumArt != null
                                  ? FileImage(File(widget.songList[index].albumArt))
                                  : AssetImage(kPlaceholderPath),
                              fit: BoxFit.fill,
                              height: size.height*0.095,
                              width: size.width*0.18,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${widget.songList[index].title}',
                                  style: TextStyle(
                                      fontFamily: kBalooBhainaFont,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Songs.indexSelected == index ||
                                              widget.songList[index].isSelected
                                          ? (Theme.of(context).brightness == Brightness.dark
                                              ? Colors.black
                                              : Colors.white)
                                          : (Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.black)),
                                  maxLines: 1,
                                ),
                                Text('${widget.songList[index].artist}',
                                    style: TextStyle(
                                        fontFamily: kBalooBhainaFont,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Songs.indexSelected == index ||
                                            widget.songList[index].isSelected
                                            ? (Theme.of(context).brightness ==
                                            Brightness.dark
                                            ? Colors.grey
                                            : Colors.white70)
                                            : (Theme.of(context).brightness ==
                                            Brightness.dark
                                            ? Colors.white70
                                            : Colors.grey)),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                         Text('${widget.songList[index].duration}',
                            style: TextStyle(
                                fontFamily: kBalooBhainaFont,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Songs.indexSelected == index ||
                                        widget.songList[index].isSelected
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
                );
              }),
    );
  }
}


