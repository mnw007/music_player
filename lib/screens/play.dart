import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/screens/albumSongs.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/widgets/songs.dart';
import 'package:music_player/utils/player.dart';
import 'package:palette_generator/palette_generator.dart';

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
       playIcon=Icons.play_circle_filled;
       player.pause();
     }
    else if(player.isPaused)
     { play=Icons.pause_circle_filled;
        playIcon=Icons.pause_circle_filled;
       player.playMusic(widget.currentSong);
     }

     if(tabState.mounted)
       setState(()=>playIcon);
    setState((){
      play;
    });
  }

  PaletteGenerator paletteGenerator;
  ImageProvider imageProvider;
  Color sliderActiveColor = kDefaultIControlsColor;

  Future<void> _updatePaletteGenerator(ImageProvider imageProvider) async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
    setState(() {
      sliderActiveColor = paletteGenerator?.dominantColor?.color;
    });
  }

  @override
  void initState() {

    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    imageProvider = widget.currentSong.albumArt != null
        ? FileImage(File(widget.currentSong.albumArt))
        : AssetImage(kPlaceholderPath);
    _updatePaletteGenerator(imageProvider);
  }

  @override
  void dispose() {
    positionSubscription.cancel();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }//added

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double height= size.height ;
    positionSubscription = player.audioPlayer.onAudioPositionChanged.listen( (p) {
              if(mounted)
                setState(()=>position = p);
            });//added mounted check

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: height*0.35,
                decoration: BoxDecoration(
                  image: DecorationImage(image: widget.currentSong.albumArt != null
                      ? FileImage(File(widget.currentSong.albumArt))
                      : AssetImage(kPlaceholderPath),
                    fit: BoxFit.fill,
                  )
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: new Container(
                    decoration: new BoxDecoration(color: Colors.white.withOpacity(0.4)),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:20.0, left: 20, right: 20),
                    child: Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(Icons.arrow_back, size: 30,),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Text('Now Playing',
                            textAlign: TextAlign.center,
                            style: TextStyle( fontSize: 30, fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height*0.05),
                    child: Container(
                      height: height*0.35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: widget.currentSong.albumArt != null
                              ? FileImage(File(widget.currentSong.albumArt))
                              : AssetImage(kPlaceholderPath),
                          fit: BoxFit.fill,
                          width: size.width*0.7,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0,right: 10.0,top: height*0.05, bottom: 5),
            child: Text('${widget.currentSong.title}',
              style: TextStyle(
                fontFamily: kBalooBhainaFont,height: 1,
                fontSize: 28.0,letterSpacing: 1.5,),
              textAlign: TextAlign.center,overflow: TextOverflow.fade,maxLines: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('${widget.currentSong.artist}',textAlign: TextAlign.center,style: TextStyle(
                fontFamily: kBalooBhainaFont,
                color: Colors.grey,
                fontSize: 20.0,height: 1),
            ),
          ),
          SizedBox(height: height*0.05,),
          Slider(
            activeColor: sliderActiveColor,
            value: (position.inSeconds).toDouble() ?? 0.0,
            onChanged: (double value)=> setState(()=> player.seek(value.roundToDouble())),
            min:0.0,max: widget?.currentSong?.time?.floorToDouble(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Text(getTime(), textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.grey, fontFamily: kBalooBhainaFont, fontSize: 18, height: 1, fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Text('${widget.currentSong.duration}', textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.grey, fontFamily: kBalooBhainaFont, fontSize: 18, height: 1, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Icon(Icons.skip_previous,size: size.width*0.15,color: kDefaultIControlsColor),
                onTap: ()=>prevSong()
              ),
              InkWell(
                  child:Icon(playIcon,size:  size.width*0.22,color: kDefaultIControlsColor,),
                  onTap: ()=>toggle()
                  ),
              InkWell(
                  child: Icon(Icons.skip_next,size:  size.width*0.15,color: kDefaultIControlsColor,),
                      onTap: ()=>nextSong(true)
              ),
            ],
          ),
        ]
        ),
      ),
    );
  }

}
