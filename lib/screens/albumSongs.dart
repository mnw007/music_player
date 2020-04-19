import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/widgets/drawer.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/utils/localizations.dart';
import 'package:music_player/screens/play.dart';
import 'package:music_player/utils/player.dart';
import 'package:music_player/screens/playlist.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/widgets/songs.dart';

import '../models/album.dart';

_AlbumSongsState albumState;
List<Song> playingList;
class AlbumSongs extends StatefulWidget {
  final Album songs;
  bool isPlaylist;
  AlbumSongs(this.songs,{this.isPlaylist=false});
  static int indexSelected;

  @override
  _AlbumSongsState createState() => albumState=_AlbumSongsState();
}

class _AlbumSongsState extends State<AlbumSongs> {
  bool isSelected=false;
  MyPlayer mPlayer= MyPlayer();
  List<Song> addList=List();

  void delete(){

    for(int i=0;i<widget.songs.album.length;){
      if(widget.songs.album[i].isSelected)
       {   widget.songs.album.remove(widget.songs.album[i]);
            i=0;
       }
       else
         i++;
    }
    editFile();
    setState(() {
      widget.songs.album;
      isSelected=false;
      AlbumSongs.indexSelected=null;
    });
  }

  @override
  void initState(){
    super.initState();
    AlbumSongs.indexSelected=null;
  }

  void selectAll(){
    widget.songs.album.forEach((song){
      song.isSelected=true;
    });
    setState(() {
      widget.songs.album;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: player!=null?songBar():null,
      drawer: NavDrawer(),
      appBar: AppBar(
        title: !isSearch ? Text(MyLocalizations.of(context).music): Container(child: TextField(controller: controller,autofocus:true,decoration: InputDecoration(hintText: '     ${MyLocalizations.of(context).search}',fillColor:Theme.of(context).scaffoldBackgroundColor, ),onSubmitted: (_)=>search(context)),decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),) ,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0),
            child: IconButton(icon:isSearch?Icon(Icons.clear):Icon(Icons.search),onPressed:()=> setState((){isSearch=!isSearch;controller.text='';}),),
          ),
          !isSelected? Container():IconButton(icon: Icon(Icons.select_all), onPressed: selectAll),
          !isSelected? Container():IconButton(icon: Icon(Icons.delete), onPressed: delete),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10.0,top: MediaQuery.of(context).size.height*0.05),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                        backgroundImage:widget.songs.album.isNotEmpty
                          ?  (widget.songs.album[0].albumArt)== null?AssetImage('img/placeholder.png'): FileImage(File(widget.songs.album[0].albumArt))
                          : AssetImage('img/placeholder.png'),radius: MediaQuery.of(context).size.height*0.15,
                    ),
                    Padding(
                      padding: EdgeInsets.only( top: MediaQuery.of(context).size.height*0.03,left: 10.0,right: 10.0),
                      child: Text('${widget.songs.name}',
                        style: TextStyle(fontSize: 22.0,letterSpacing: 1.5,fontWeight: FontWeight.w500),textAlign: TextAlign.center,overflow: TextOverflow.fade,maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                child: ListView.builder(
                    itemCount: widget.songs.album.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: AlbumSongs.indexSelected==index || widget.songs.album[index].isSelected ? Colors.brown[400]: Theme.of(context).scaffoldBackgroundColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: widget.songs.album[index].albumArt != null
                                ? FileImage(File(widget.songs.album[index].albumArt))
                                : AssetImage('img/placeholder.png'),
                          ),
                          title: Text('${widget.songs.album[index].title}',overflow: TextOverflow.clip,maxLines: 2,style: TextStyle(color: AlbumSongs.indexSelected==index || widget.songs.album[index].isSelected ? (Theme.of(context).brightness==Brightness.dark? Colors.black:Colors.white) : (Theme.of(context).brightness==Brightness.dark? Colors.white:Colors.black))),
                          subtitle: Text('${widget.songs.album[index].artist}',style: TextStyle(color: AlbumSongs.indexSelected==index || widget.songs.album[index].isSelected? (Theme.of(context).brightness==Brightness.dark? Colors.black:Colors.white70) : (Theme.of(context).brightness==Brightness.dark? Colors.white70:Colors.black))),
                          trailing: Text('${widget.songs.album[index].duration}',style: TextStyle(color: AlbumSongs.indexSelected==index || widget.songs.album[index].isSelected? (Theme.of(context).brightness==Brightness.dark? Colors.black:Colors.white) : (Theme.of(context).brightness==Brightness.dark? Colors.white:Colors.black))),
                          onTap: (){
                            setState(() {
                              if(!isSelected)
                                AlbumSongs.indexSelected= index;
                              else
                              {
                                widget.songs.album[index].isSelected=!widget.songs.album[index].isSelected;
                                if(AlbumSongs.indexSelected== index)
                                  AlbumSongs.indexSelected=null;
                                widget.songs.album[index].isSelected? addList.add(widget.songs.album[index]): addList.remove(widget.songs.album[index]);
                              }
                            });
                            Songs.indexSelected=null;
                            if(!isSelected) {
                              playingList=widget.songs.album;
                              isAlbum=true;
                              mPlayer.playMusic(widget.songs.album[index]);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Play(widget.songs.album, widget.songs.album[index], index)));
                              }
                            if(addList.isEmpty)
                            setState(() {
                              isSelected=false;
                            });
                            },
                          onLongPress: (){
                            if(widget.isPlaylist)
                              setState(() {
                                widget.songs.album[index].isSelected=true;
                                addList.add(widget.songs.album[index]);
                                AlbumSongs.indexSelected= index;
                                isSelected=true;
                              });
                            else
                              null;
                          },
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
