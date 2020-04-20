import 'dart:async';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:local_notifications/local_notifications.dart';
import 'package:music_player/screens/albumSongs.dart';
import 'package:music_player/screens/home.dart';
import 'package:music_player/screens/play.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/widgets/songs.dart';

typedef void OnError(Exception exception);
enum PlayerState { stopped, playing, paused }

bool isAlbum=false;
class MyPlayer{

  static final MyPlayer _player = MyPlayer._internal();

  factory MyPlayer() => _player;

  MyPlayer._internal();

  Song currentSong;
  AudioPlayer audioPlayer;
  bool isPrevPlayed=false;
  bool isNextPlayed=false;
  Duration position= new Duration(seconds: 0);
  PlayerState playerState = PlayerState.stopped;
  StreamSubscription audioPlayerStateSubscription;

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
          if (s == AudioPlayerState.STOPPED) {
            onStop();
          }
          else if(s== AudioPlayerState.COMPLETED) {
            onComplete();
          }
        }, onError: (msg) {
            playerState = PlayerState.stopped;
            position = new Duration(seconds: 0);
        });
  }

  Future playMusic(Song song) async {
    if((isPlaying||isPaused) &&currentSong!=song)
     {
       await audioPlayer.stop();
     }
    currentSong= song;
    await audioPlayer.play(currentSong.data);
    playerState = PlayerState.playing;
    if(player==null)
      player=MyPlayer();
    tabState.setState(()=>player);
    generateNotification();
  }

  Future pause() async {
    await audioPlayer.pause();
    playerState = PlayerState.paused;
  }

  Future stop() async {
    await audioPlayer.stop();
    playerState = PlayerState.stopped;
    position = new Duration(seconds: 0);
  }

  Future seek(double value) async {
    await audioPlayer.seek(value);
  }

  void setPrevPlayed(bool value) => isPrevPlayed=value;
  void setNextPlayed(bool value) => isNextPlayed=value;
  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  void onStop() {
    if(isNextPlayed)
    {
      playMusic(currentSong);
      isNextPlayed=false;
    }
    else if(isPrevPlayed)
    {
      playMusic(currentSong);
      isPrevPlayed=false;
    }
    else {
      stop();
    }
  }

  void onComplete(){
    playerState=PlayerState.stopped;
    if(state.mounted)
      state.nextSong(false);
    else
      nextSong(false);
  }

  void nextSong(bool value){
    if(value)
      setNextPlayed(true);
    stop();
    if(!isAlbum){
      if(Songs.indexSelected != TabView.songList.length-1)
      {
        Songs.indexSelected++;
        position = Duration(seconds: 0);
        currentSong = TabView.songList[Songs.indexSelected];
        stateSong.setState(()=>Songs.indexSelected);
      }
      else {
        Songs.indexSelected = 0;
        position = Duration(seconds: 0);
        currentSong = TabView.songList[Songs.indexSelected];
        stateSong.setState(()=>Songs.indexSelected);
      }
    }
    else{
      if(AlbumSongs.indexSelected != playingList.length-1)
      {
        AlbumSongs.indexSelected++;
        position = Duration(seconds: 0);
        currentSong = playingList[AlbumSongs.indexSelected];
        albumState.setState(()=>AlbumSongs.indexSelected);
      }
      else {
        AlbumSongs.indexSelected = 0;
        position = Duration(seconds: 0);
        currentSong = playingList[AlbumSongs.indexSelected];
        albumState.setState(()=>AlbumSongs.indexSelected);
      }
    }
    if(state.mounted)
      state.setState(()=>state.song(currentSong));
  }

  void prevSong() {

    setPrevPlayed(true);
    stop();
    if(!isAlbum){
      if(Songs.indexSelected !=0)
      {
        Songs.indexSelected --;
        position=Duration(seconds: 0);
        currentSong=TabView.songList[Songs.indexSelected];
        stateSong.setState(()=>Songs.indexSelected);
      }
      else
      {
        Songs.indexSelected =TabView.songList.length-1;
        position=Duration(seconds: 0);
        currentSong=TabView.songList[Songs.indexSelected];
        stateSong.setState(()=>Songs.indexSelected);
      }
    }
   else{
      if(AlbumSongs.indexSelected !=0)
      {
        AlbumSongs.indexSelected--;
        position=Duration(seconds: 0);
        currentSong=playingList[AlbumSongs.indexSelected];
        albumState.setState(()=>AlbumSongs.indexSelected);
      }
      else
      {
        AlbumSongs.indexSelected =playingList.length-1;
        position=Duration(seconds: 0);
        currentSong=playingList[AlbumSongs.indexSelected];
        albumState.setState(()=>AlbumSongs.indexSelected);
      }

    }
    if(state.mounted)
      state.setState(()=>state.song(currentSong));
  }

  void toggle() {
    if(state!=null && state.mounted)
      state.setState(()=>state.toggle());
    else{
      if(isPlaying)
        {
          pause();
          playIcon=Icons.play_circle_filled;
        }
      else if(isPaused)
        {
          playMusic(currentSong);
          playIcon=Icons.pause_circle_filled;
        }
    }
    if(tabState!=null && tabState.mounted)
      tabState.setState(()=>playIcon);
    if(albumState!=null && albumState.mounted)
      albumState.setState(()=>playIcon);
  }

  void generateNotification() async{

    await LocalNotifications.createNotification(
        id: 0,
        title: '${currentSong.title}',
        content: '${currentSong.artist}',
        androidSettings: new AndroidSettings(
            isOngoing: true,
          vibratePattern: AndroidVibratePatterns.NONE
        ),
        actions: [
          new NotificationAction(
              actionText: 'Prev',
              callback: onReplyClick,
              payload: 'previousSong',
              launchesApp: false
          ),
          new NotificationAction(
              actionText: 'Toggle',
              callback: onReplyClick,
              payload: 'pause',
              launchesApp: false
          ),
          new NotificationAction(
              actionText: 'Next',
              callback: onReplyClick,
              payload: 'nextSong',
              launchesApp: false
          ),
        ]
    );
  }

  void onReplyClick(String payload) {
   if(payload=='previousSong')
        prevSong();
   else if(payload=='pause')
       toggle();
   else if(payload=='nextSong')
       nextSong(true);
  }
}


