class Song{

  String _title;
  String _data;
  String _album;
  String _artist;
  String _albumArt;
  String _duration;
  bool _isSelected=false;
  int min;
  int sec;
  int time;

  Song(this._title,this._data,this._album,this._albumArt,this._artist,this._duration);

  get isSelected => this._isSelected;
  String get title => this._title;
  String get data => this._data;
  String get album => this._album;
  String get artist => this._artist;
  String get albumArt => this._albumArt;
  String get duration {
    time=int.parse(this._duration);
    time= (time/1000).floor();
     min=(time/60).floor();
     sec= time-min*60;
    String secs= sec>9? '$sec': '0$sec';
    return '$min:$secs';
  }

  set isSelected(bool value) => this._isSelected=value;
  set title(String title)=> this._title=title;
  set data(String data)=> this._data=data;
  set album(String album)=> this._album=album;
  set artist(String artist)=> this._artist=artist;
  set albumArt(String art)=> this._albumArt=art;
  set duration(String dur)=> this._duration=dur;

  static Song fromJson(dynamic json) {
    return new Song(json['Title'],json['Data'], json['Album'], json['AlbumArt'], json['Artist'], json['Duration']);
  }

  Map<String, dynamic> toJson()=>{
    'Title': _title,
    'Data': _data,
    'Album': _album,
    'AlbumArt':_albumArt,
    'Artist': _artist,
    'Duration': _duration,
  };
}