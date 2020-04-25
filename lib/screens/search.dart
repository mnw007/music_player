import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/widgets/drawer.dart';
import 'package:music_player/utils/localizations.dart';
import 'package:music_player/utils/player.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/widgets/songs.dart';

class SearchResult extends StatelessWidget {

  final String title;
  final List<Song> songs;
  final String message;

  SearchResult(this.title,this.songs,this.message);

  final MyPlayer player= MyPlayer();

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('${MyLocalizations.of(context).results} "$title"')),
      body: Container(
        child: message!=null ? Container(
          padding: EdgeInsets.symmetric(horizontal: size.width*0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(MyLocalizations.of(context).noSong,style: TextStyle(fontSize: 25.0,letterSpacing: 1.0,wordSpacing: 3.0),textAlign: TextAlign.center,),
              Image(image: AssetImage(kPlaceholderPath),width: size.width*0.7,height: size.height*0.3,)
            ],
          ),
        ):
        Container(
          padding: EdgeInsets.only(top: size.height*0.03,left: size.width*0.02 ),
          child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return Container(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: songs[index].albumArt!=null ? FileImage(File(songs[index].albumArt)):
                      AssetImage(kPlaceholderPath),
                    ),
                    title: Text('${songs[index].title}',),
                    trailing: Text('${songs[index].duration}',),
                    subtitle: Text('${songs[index].artist}',),
                    onTap: (){
                        Songs.indexSelected=null;
                      if(player.isPlaying)
                        player.stop();
                      player.playMusic(songs[index]);
                      Navigator.pop(context);
                      },
                  ),
                );
              }),
        )
      ),
    );
  }
}

