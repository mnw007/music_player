import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/albumSongs.dart';
import 'package:music_player/home.dart';
import 'package:music_player/song.dart';

class Album {
  List<Song> album = List();
  String name;
  String albumArt;

  Album(this.name, this.albumArt);
  Album.fromPlaylist(this.name);

  get songs=>this.album;
  void albumSongs(Song song) => this.album.add(song);
  void addAlbum(List<Song> album) => this.album.addAll(album);
}

bool isChanged=false;
class Albums extends StatefulWidget {
  List<Song> songList;
  List<Album> albums=List();
  Albums();

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {

  void createAlbums() {
    isChanged=false;
    widget.albums.add(Album(widget.songList[0].album, widget.songList[0].albumArt));
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
    setState(() {
      widget.albums;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (widget.songList == null) {
      setState(() {
        widget.songList = TabView.songList;
      });
     if(widget.songList!=null)
       createAlbums();
    }
    if(isChanged)
      createAlbums();
    return Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.03,left: MediaQuery.of(context).size.width*0.02 ),
        child: widget.songList == null
            ? Image(image: AssetImage('img/placeholder.png'),)
            : ListView.builder(
                itemCount: widget.albums.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.015),
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: widget.albums[index].albumArt != null
                          ? FileImage(File(widget.albums[index].albumArt))
                          : AssetImage('img/placeholder.png'),radius: 50.0,),
                      title: Container(padding:EdgeInsets.only(left:MediaQuery.of(context).size.width*0.015),child: Text('${widget.albums[index].name}',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500),overflow: TextOverflow.clip,maxLines: 2,)),
                      contentPadding: const EdgeInsets.only(top: 15.0,left: 8.0,bottom: 15.0),
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AlbumSongs(widget.albums[index])));},
                    ),
                  );
                },
              ));
  }
}
