import 'package:flutter/material.dart';
import 'package:music_player/utils/localizations.dart';
import 'package:music_player/screens/playlist.dart';
import 'package:music_player/screens/settings.dart';

class NavDrawer extends StatelessWidget {
  final bool shouldReplace;
  NavDrawer({this.shouldReplace=false});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.only(left: 10.0,top: 30.0),
          children: <Widget>[
            ListTile(leading: Icon(Icons.menu),onTap: (){
              Navigator.pop(context);
            },),
            Container(height: 25.0,),
            ListTile(
              leading: Icon(Icons.playlist_play),
              title: Text(MyLocalizations.of(context).playlist),
              onTap: (){
                Navigator.pop(context);
                if(shouldReplace)
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Playlist()));
                else
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Playlist()));
              },
            ),
            ListTile(title: Text(MyLocalizations.of(context).settings),
            leading: Icon(Icons.settings),
            onTap: (){
              Navigator.pop(context);
              if(shouldReplace)
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Settings()));
              else
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Settings()));
            },
            )
          ]
        ),
      )
    );
  }
}


