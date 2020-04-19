import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/screens/albumSongs.dart';
import 'package:music_player/widgets/drawer.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/utils/localizations.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/widgets/songs.dart';
import 'package:music_player/utils/player.dart';

typedef void OnError(Exception exception);
enum PlayerState { stopped, playing, paused }
_PlayState state;

class Play extends StatefulWidget {
  List<Song> songs;
  Song currentSong;
  int index;

 Play([this.songs,this.currentSong,this.index]);

 void setValues(List<Song> songs, Song currentSong, int index){
   this.songs=songs;
   this.currentSong=currentSong;
   this.index=index;
 }

  @override
  _PlayState createState() => state=_PlayState();
}

class _PlayState extends State<Play> {

  void song(Song value)=>widget.currentSong=value;

  MyPlayer player= MyPlayer();
  IconData play=Icons.pause_circle_filled;
  StreamSubscription positionSubscription;
  Duration position= new Duration(seconds: 0);

  String getTime(){
    String min,secs;
    min= position.inMinutes >9 ?'${position.inMinutes}':'0${position?.inMinutes}';
    secs= (position.inSeconds-60*int.parse(min)) >9 ?'${position.inSeconds-60*int.parse(min)}':'0${position.inSeconds-60*int.parse(min)}';
    return '$min:$secs';
  }

  void nextSong(bool value){
    if(value)
       player.setNextPlayed(true);
    player.stop();
    widget.index != widget.songs.length-1 ?
              setState((){widget.index++;
              play=Icons.pause_circle_filled;
              position=Duration(seconds: 0);
              widget.currentSong=widget.songs[widget.index];
              isAlbum?AlbumSongs.indexSelected=widget.index: Songs.indexSelected=widget.index;
              player.currentSong=widget.currentSong;})
              :   setState((){widget.index=0;
                  play=Icons.pause_circle_filled;
                  position=Duration(seconds: 0);
                  widget.currentSong=widget.songs[widget.index];
                  isAlbum?AlbumSongs.indexSelected=widget.index: Songs.indexSelected=widget.index;
                  player.currentSong=widget.currentSong;});

   // player.playMusic(widget.currentSong);
  }

  void prevSong() {
    player.setPrevPlayed(true);
    player.stop();
    if(widget.index!=0)
      setState(() {
        widget.index--;
        play=Icons.pause_circle_filled;
        position=Duration(seconds: 0);
        widget.currentSong=widget.songs[widget.index];
       isAlbum?albumState.setState(()=>AlbumSongs.indexSelected=widget.index): stateSong.setState(()=>Songs.indexSelected=widget.index);
        player.currentSong=widget.currentSong;
      });
    else
      setState(() {
        widget.index=widget.songs.length-1;
        play=Icons.pause_circle_filled;
        position=Duration(seconds: 0);
        widget.currentSong=widget.songs[widget.index];
        isAlbum?AlbumSongs.indexSelected=widget.index: Songs.indexSelected=widget.index;
        player.currentSong=widget.currentSong;
      });
    //player.playMusic(widget.currentSong);
  }

  void toggle(){

    if(player.isPlaying)
     {
       play=Icons.play_circle_filled;
       playIcon=Icons.play_arrow;
       player.pause();
     }
    else if(player.isPaused)
     { play=Icons.pause_circle_filled;
        playIcon=Icons.pause;
       player.playMusic(widget.currentSong);
     }

     if(tabState.mounted)
       setState(()=>playIcon);
    setState((){
      play;
    });
  }

  @override
  void dispose() {
    positionSubscription.cancel();
    super.dispose();
  }//added

  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height ;
   positionSubscription = player.audioPlayer.onAudioPositionChanged.listen( (p) {if(mounted)setState(()=>position = p);});//added mounted check
    return Scaffold(
      drawer: NavDrawer(shouldReplace: true),
      appBar: AppBar(
        title: !isSearch ? Text('Music'): Container(child: TextField(controller: controller,autofocus:true,decoration: InputDecoration(hintText: '     ${MyLocalizations.of(context).search}',fillColor:Theme.of(context).scaffoldBackgroundColor, ),onSubmitted: (_)=>search(context)),decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),) ,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon: isSearch?Icon(Icons.close):Icon(Icons.search),onPressed:()=> setState((){isSearch=!isSearch;controller.text='';}),),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child:Column(children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: height*0.05),
                  child: CircleAvatar(
                    backgroundImage:widget.currentSong.albumArt != null
                        ? FileImage(File(widget.currentSong.albumArt))
                        : AssetImage('img/placeholder.png'),radius: height*0.2
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0,right: 10.0,top: height*0.04),
                  child: Text('${widget.currentSong.title}',
                    style: TextStyle(fontSize: 22.0,letterSpacing: 1.5,),textAlign: TextAlign.center,overflow: TextOverflow.fade,maxLines: 2,
                  ),
                ),
                Text('${widget.currentSong.artist}',textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0),),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: height*0.05),
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(getTime()),
                    ),
                    Expanded(flex:9,child: Slider(
                      value: (position.inSeconds).toDouble() ?? 0.0,
                      onChanged: (double value){
                        setState((){player.seek(value.roundToDouble());
                        position;});},
                      min:0.0,max: widget.currentSong.time.floorToDouble(),)),
                    Padding(
                      padding: const EdgeInsets.only(right:  8.0),
                      child: Text('${widget.currentSong.duration}'),
                    ),
                  ],),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(padding:const EdgeInsets.only(top: 10.0),child: IconButton(icon: Icon(Icons.skip_previous,size: 50.0,color: Colors.brown), onPressed: (){prevSong();}),height: 80.0,),
                      Container(child: IconButton(icon: Icon(play,size: 70.0,color: Colors.brown,), onPressed: (){toggle();}),height: 80.0),
                      Container(padding:const EdgeInsets.only(top: 10.0,left: 10.0),child: IconButton(icon: Icon(Icons.skip_next,size: 50.0,color: Colors.brown,), onPressed: (){nextSong(true);}),height: 80.0),
                    ],
                  )
                ],
              ),
            ),
          ])
        ),
      ),
    );
  }

}
