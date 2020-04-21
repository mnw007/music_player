import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/screens/play.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/widgets/songs.dart';

class SongBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 15,
            color: Color(0xFF757575).withOpacity(.8),
          )
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image(
                image: player.currentSong.albumArt != null
                    ? FileImage(File(player.currentSong.albumArt))
                    : AssetImage(kPlaceholderPath),
                fit: BoxFit.fill,
                height: height * 0.075,
                width: width * 0.15,
              ),
            ),
          ),
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    player.playMusic(player.currentSong);
                    Navigator.push(
                        scaffoldState.currentContext,
                        MaterialPageRoute(
                            builder: (context) => Play(TabView.songList,
                                player.currentSong, Songs.indexSelected)));
                  },
                  child: Text(
                    player.currentSong.title,
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: kBalooBhainaFont,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    maxLines: 1,
                  ))),
          GestureDetector(
              child: Icon(
                Icons.skip_previous,
                color: Colors.black,
                size: width * 0.08,
              ),
              onTap: () => player.prevSong()),
//        Icon(playIcon, color: Colors.black, size: width * 0.16),
          GestureDetector(
              child: Icon(playIcon, color: Colors.black, size: width * 0.16),
              onTap: () => player.toggle()),
          GestureDetector(
              child: Icon(Icons.skip_next,
                  color: Colors.black, size: width * 0.08),
              onTap: () => player.nextSong(true)),
        ],
      ),
    );
  }
}
