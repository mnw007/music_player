import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/utils/constants.dart';

class AlbumItem extends StatelessWidget {
  final String image;
  final String name;

  AlbumItem({Key key, this.image, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 20,
                    color: Color(0xFF757575).withOpacity(.10),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: image != null
                      ? FileImage(File(image))
                      : AssetImage(kPlaceholderPath),
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.play_circle_outline,
                  size: 35,
                ),
              ),
            )
          ]),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '$name',
          style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.w800,
              fontFamily: kBalooBhainaFont),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ],
    );
  }
}
