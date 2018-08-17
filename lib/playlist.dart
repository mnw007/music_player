import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/albumSongs.dart';
import 'package:music_player/localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:music_player/albums.dart';
import 'package:music_player/drawer.dart';
import 'package:music_player/home.dart';
import 'package:music_player/song.dart';

List<Album> playlist = List();
_PlaylistState playlistState;

void addSongs(List<Song> songList){

  int items=playlist.length;
  ListView list=ListView.builder(
      itemCount: items,
      itemBuilder: (context,index){
        return ListTile(
            title: Text('${playlist[index].name}'),
            onTap: (){
             int result= checkDuplicate(songList, playlist[index]);
             if(result==1)
             {  playlist[index].addAlbum(songList);
                editFile();
                showMessage(scaffoldState.currentState, '${songList[0].title} ${songList.length-1>0? '+ ${songList.length-1}':''} ${MyLocalizations.of(scaffoldState.currentContext).added}');
             }
              Navigator.pop(context);
            },
        );
      });

  showDialog(context: scaffoldState.currentContext,
    builder: (_)=>SimpleDialog(
      title: Text('${MyLocalizations.of(scaffoldState.currentContext).select}'),
      children: <Widget>[
        Column(children: <Widget>[
              ListTile(title: Text('${MyLocalizations.of(scaffoldState.currentContext).create} ${MyLocalizations.of(scaffoldState.currentContext).playlist}'),onTap: (){
                Navigator.pop(scaffoldState.currentContext);
                createPlaylist(scaffoldState.currentState,songs: songList);
              },
                leading: Icon(Icons.add),
              ),
              Container(height:100.0,width:130.0,child: list,)
            ],
        )
      ],
    )
  );
}

void createPlaylist(ScaffoldState scaffold,{List<Song> songs}){

  TextEditingController controller=TextEditingController();
  IconData icon=Icons.create;
  showDialog(context: scaffold.context,barrierDismissible: false,
  builder: (_)=>SimpleDialog(
    title: Text('${MyLocalizations.of(scaffold.context).create} ${MyLocalizations.of(scaffold.context).playlist}'),
    children: <Widget>[
      TextField(controller: controller,autofocus:true,decoration: InputDecoration(hintText: '  ${MyLocalizations.of(scaffold.context).enter}',suffixIcon: Icon(icon),contentPadding: const EdgeInsets.all(8.0)),onSubmitted: (_){
      },),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(child: Text(MyLocalizations.of(scaffold.context).create),
              onPressed: (){
                if(controller.text.isEmpty)//check for blank name
                  showMessage(scaffold, '${MyLocalizations.of(scaffold.context).invalidName}');
                else{
                  bool available=true;
                  for(int i=0;i<playlist.length;i++){//check for same name
                    if(controller.text==playlist[i].name) {
                      available=false;
                      showMessage(scaffold,'${controller.text} ${MyLocalizations.of(scaffold.context).already}');
                      break;
                    }
                  }
                  if(available)//adding song if name is valid
                  {
                    if(songs==null)//blank playlist
                      {
                        playlist.add(Album(controller.text,'img/placeholder.png' ));
                        editFile();
                        Navigator.pop(scaffold.context);
                      }
                    else {
                      playlist.add(Album(controller.text, songs[0].albumArt));
                      playlist.last.addAlbum(songs);
                      editFile();
                      showMessage(scaffold, '${songs[0].title} ${songs.length - 1 > 0 ? '+ ${songs.length - 1}' : ''} ${MyLocalizations.of(scaffold.context).added}');
                      Navigator.pop(scaffold.context);
                    }
                  }
                }
            },),
            RaisedButton(onPressed: ()=>Navigator.pop(scaffold.context),child: Text(MyLocalizations.of(scaffold.context).cancel),color: Colors.red[200],)
          ],
        ),
      )
    ]
  ));
}

void editFile()async {

  final appDir = await getApplicationDocumentsDirectory();
  String path= appDir.path;
  File playList=File('$path/playlist.txt');
  if(! playList.existsSync())
    playList.create();
  playList.writeAsStringSync('');
  playlist.forEach((albums){
    String data=json.encode(albums.songs);
    playList.writeAsStringSync('${albums.name}>>>',mode: FileMode.append);
    playList.writeAsStringSync(data,mode: FileMode.append);
    playList.writeAsStringSync('***',mode: FileMode.append);
  });
}

int checkDuplicate(List<Song> song,Album playlist){

  for(int i=0;i<playlist.album.length;i++){
    print(playlist.album[i].title);
    for(int j=0;j<song.length;j++)
    {
      print(song[j].title);
      if (song[j].title == playlist.album[i].title) {
        showMessage(scaffoldState.currentState,
            '${song[j].title} ${MyLocalizations.of(scaffoldState.currentContext).already} ${playlist.name}');
        return 0;
      }
    }
  }
  return 1;
}

class Playlist extends StatefulWidget {

  @override
  _PlaylistState createState() {
    return playlistState= _PlaylistState();
  }
}

class _PlaylistState extends State<Playlist> {

  bool isLongPressed=false;
  int selectedIndex;
  final GlobalKey<ScaffoldState> myScaff= GlobalKey();

  void deletePlaylist(int index){
    showDialog(context: context,barrierDismissible: false,
    builder: (_)=>SimpleDialog(
      title: Text('${MyLocalizations.of(context).delete} ${playlist[index].name}'),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(onPressed: (){
              playlist.removeAt(index);
              editFile();
              setState(() {
                isLongPressed=false;
                selectedIndex=null;
              });
              Navigator.pop(context);
             },child: Text('${MyLocalizations.of(context).delete}'),
            ),
            RaisedButton(onPressed: (){
              setState(() {
                isLongPressed=false;
                selectedIndex=null;
              });
              Navigator.pop(context);
            },child: Text(MyLocalizations.of(context).cancel),color: Colors.red[200],)
          ],
        ),

      ],
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      key: myScaff,
        drawer: NavDrawer(shouldReplace: true,),
        appBar: AppBar(
          title: !isSearch
              ? Text(MyLocalizations.of(context).playlist)
              : Container(
                  child: TextField(
                      controller: controller,autofocus:true,
                      decoration: InputDecoration(
                        hintText: '     ${MyLocalizations.of(context).search}',
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      onSubmitted: (_) => search(context)),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(icon: isSearch?Icon(Icons.clear):Icon(Icons.search),
                onPressed: () => setState(() {
                      isSearch = !isSearch;
                      controller.text = '';
                    }),
              ),
            ),
            isLongPressed?IconButton(icon: Icon(Icons.delete), onPressed: ()=>deletePlaylist(selectedIndex)):IconButton(icon: Icon(Icons.add_circle), onPressed: ()=>createPlaylist(myScaff.currentState))
          ],
        ),
        body: Container(
          child: playlist.isEmpty? Container(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(MyLocalizations.of(context).noPlaylist,style: TextStyle(fontSize: 25.0,letterSpacing: 1.0,wordSpacing: 3.0),textAlign: TextAlign.center,),
                 Image(image: AssetImage('img/placeholder.png'),width: size.width*0.7,height: size.height*0.3,)
              ],
            ),
          ):
              Container(
                padding: EdgeInsets.only(top: size.height*0.03,left: size.width*0.02 ),
                child: ListView.builder(
                    itemCount: playlist.length,
                    itemBuilder: (context,index){
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: size.height*0.015),
                        color: selectedIndex==index?Colors.brown[400]: Theme.of(context).scaffoldBackgroundColor,
                        child: ListTile(
                          leading: CircleAvatar(backgroundImage: playlist[index].album.isNotEmpty
                              ? (playlist[index].album[0].albumArt)== null?AssetImage('img/placeholder.png'): FileImage(File(playlist[index].album[0].albumArt))
                              : AssetImage('img/placeholder.png'),radius: 50.0,),
                          title: Container(padding:EdgeInsets.only(left: size.width*0.015),child: Text('${playlist[index].name}',style: TextStyle(fontSize: 23.0,fontWeight: FontWeight.w400,color:selectedIndex==index ? (Theme.of(context).brightness==Brightness.dark? Colors.black:Colors.white) : (Theme.of(context).brightness==Brightness.dark? Colors.white:Colors.black)),)),
                          contentPadding: const EdgeInsets.only(top: 15.0,left: 8.0,bottom: 15.0),
                          onTap:(){
                            if(isLongPressed)
                              {
                                setState(() {
                                  isLongPressed=false;
                                  selectedIndex=null;
                                });
                              }
                            else
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AlbumSongs(playlist[index],isPlaylist: true,)));
                            },
                          onLongPress: (){
                            isLongPressed=true;
                            selectedIndex=index;
                            setState(() {
                              isLongPressed;
                              selectedIndex;
                            });
                          },
                        ),
                      );
                    }),
              )
          ,
        ));
  }
}
