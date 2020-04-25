import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/screens/albumSongs.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/localizations.dart';
import 'package:music_player/widgets/album-grid-item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/models/song.dart';

import '../models/album.dart';

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
             if(isNameAvailable(songList, playlist[index]))
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
                        playlist.add(Album(controller.text,kPlaceholderPath ));
                    else {
                      playlist.add(Album(controller.text, songs[0].albumArt));
                      playlist.last.addAlbum(songs);
                      showMessage(scaffold, '${songs[0].title} ${songs.length - 1 > 0 ? '+ ${songs.length - 1}' : ''} ${MyLocalizations.of(scaffold.context).added}');
                    }
                    editFile();
                    Navigator.pop(scaffold.context);
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

bool isNameAvailable(List<Song> song,Album playlist){
  for(int i=0;i<playlist.album.length;i++){
    for(int j=0;j<song.length;j++)
    {
      if (song[j].title == playlist.album[i].title) {
        showMessage(scaffoldState.currentState,
            '${song[j].title} ${MyLocalizations.of(scaffoldState.currentContext).already} ${playlist.name}');
        return false;
      }
    }
  }
  return true;
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
    final orientation = MediaQuery.of(context).orientation;
    final Size size=MediaQuery.of(context).size;
    return Scaffold(
      key: myScaff,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: !isSearch
              ? Text(MyLocalizations.of(context).playlist,   style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w500,
          ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            maxLines: 1,)
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
                 Image(image: AssetImage(kPlaceholderPath),width: size.width*0.7,height: size.height*0.3,)
              ],
            ),
          ):
          GridView.builder(
            padding: EdgeInsets.only(bottom: size.height * 0.15),
            itemCount: playlist.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: size.aspectRatio * 1.65,
                crossAxisCount:
                (orientation == Orientation.portrait) ? 2 : 3),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridTile(
                    child: AlbumItem(
                      image: playlist[index].album.isNotEmpty?playlist[index].album[0].albumArt:null,
                      name: playlist[index].name,
                    ),
                  ),
                ),
                onTap:(){
                  if(isLongPressed)
                  {
                    setState(() {
                      isLongPressed=false;
                      selectedIndex=null;
                    });
                  }
                  else
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AlbumSongs(playlist[index],isPlaylist: true,)));
                },
                onLongPress: (){
                  setState(() {
                    isLongPressed=true;
                    selectedIndex=index;
                  });
                },
              );
            },
          ),
        ),
      floatingActionButton: FloatingActionButton(onPressed:() =>createPlaylist(myScaff.currentState),
        child: Icon(Icons.add, size: 35,),
        tooltip: 'Add Playlist',
      ),
    );
  }
}
