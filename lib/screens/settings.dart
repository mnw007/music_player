import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:music_player/widgets/drawer.dart';
import 'package:music_player/utils/localizations.dart';
import 'package:music_player/screens/albums.dart';
import 'package:url_launcher/url_launcher.dart';

int themeValue;

class Settings extends StatefulWidget {

  @override
  SettingsState createState() {
    return new SettingsState();
  }
}

class SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text(MyLocalizations.of(context).settings),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: EdgeInsets.only(top: size.height*0.05,left: size.width*0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0,left: 20.0),
                child: Text('${MyLocalizations.of(context).mode}',style: TextStyle(fontSize: 20.0),),
              ),
              RadioListTile<int>(
                title: Text('${MyLocalizations.of(context).dark}'),
                value: 0,
                groupValue: themeValue,
                onChanged: (value){
                  DynamicTheme.of(context).setBrightness(Brightness.dark);
                  setState(() {
                    themeValue=value;
                    isChanged=true;
                  });
                }
              ),
              RadioListTile<int>(
                title: Text('${MyLocalizations.of(context).regular}'),
                value: 1,
                groupValue: themeValue,
                onChanged: (value){
                  DynamicTheme.of(context).setBrightness(Brightness.light);
                  setState(() {
                    themeValue=value;
                    isChanged=true;
                  });
                },
              ),
              RadioListTile<int>(
                title: Text('${MyLocalizations.of(context).system}'),
                value: 2,
                groupValue: themeValue,
                onChanged: (value){
                  DynamicTheme.of(context).setBrightness(Brightness.light);
                  setState(() {
                    themeValue=value;
                    isChanged=true;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.35),
                child: Divider(),
              ),
              Container(
                child: GestureDetector(child: Text('Contact Us',style: TextStyle(fontSize: 20.0,decoration: TextDecoration.underline)),
                onTap: ()=>launchUrl('https://github.com/mnw007'),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text('Version: 1.0'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

}
