import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/screens/settings.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Icon(Icons.settings),
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Settings()));
      },
    );
  }
}
