import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/drawer.dart';
import 'package:music_player/localizations.dart';
import 'package:music_player/player.dart';
import 'package:music_player/song.dart';
import 'package:music_player/songs.dart';

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
      drawer: NavDrawer(),
      body: Container(
        child: message!=null ? Container(
          padding: EdgeInsets.symmetric(horizontal: size.width*0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(MyLocalizations.of(context).noSong,style: TextStyle(fontSize: 25.0,letterSpacing: 1.0,wordSpacing: 3.0),textAlign: TextAlign.center,),
              Image(image: AssetImage('img/placeholder.png'),width: size.width*0.7,height: size.height*0.3,)
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
                      AssetImage('img/placeholder.png'),
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

