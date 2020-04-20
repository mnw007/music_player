import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class MyLocalizations {
  MyLocalizations(this.locale);

  final Locale locale;

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {

    'en': {
      'title': 'Music Player',
      'music': 'Music',
      'playlist': 'Playlist',
      'settings': 'Settings',
      'playing': 'Now Playing',
      'search': 'Search',
      'songs': 'SONGS',
      'albums': 'ALBUMS',
      'ok': 'OK',
      'no playlist': 'No Playlist Found',
      'no song': 'No Song Found',
      'invalid': 'Please Enter Valid Name',
      'cancel': 'Cancel',
      'create': 'Create',
      'added': 'added',
      'already': 'already exists in',
      'enter': 'Enter Name',
      'select': 'Select Playlist',
      'results': 'Results for',
      'delete': 'Delete',
      'mode': 'Themes',
      'dark': 'Dark',
      'regular': 'Regular',
      'system': 'System',
    },

    'es': {
      'title': 'Reproductor de música',
      'music': 'Música',
      'playlist': 'Lista de reproducción',
      'settings': 'Ajustes',
      'playing': 'Jugando ahora',
      'search': 'Buscar',
      'songs': 'Canciones',
      'albums': 'Álbumes',
      'ok': 'Aprobar',
      'no playlist': 'No se ha encontrado una lista de reproducción',
      'no song': 'No se encontró ninguna canción',
      'invalid': 'Por favor ingrese un nombre válido',
      'cancel': 'Cancelar',
      'create': 'Crear',
      'added': 'Adicional',
      'already': 'ya existe en',
      'enter': 'Ingrese su nombre',
      'select': 'Seleccionar lista de reproducción',
      'results': 'resultados para',
      'delete': 'Borrar',
      'mode': 'Temas',
      'dark': 'Oscuro',
      'regular': 'Regular',
      'system': 'Sistema',
    },

    'fr': {
      'title': 'Lecteur de musique',
      'music': 'La musique',
      'playlist': 'Playlist',
      'settings': 'Paramètres',
      'playing': 'Lecture en cours',
      'search': 'Chercher',
      'songs': 'Chansons',
      'albums': 'Des albums',
      'ok': 'D\'accord',
      'no playlist': 'Aucune liste de lecture trouvée',
      'no song': 'Aucune chanson trouvée',
      'invalid': 'Veuillez entrer un nom valide',
      'cancel': 'Annuler',
      'create': 'Créer',
      'added': 'ajoutée',
      'already': 'existe déjà dans',
      'enter': 'Entrez le nom',
      'select': 'Sélectionnez une playlist',
      'results': 'Résultats pour',
      'delete': 'Effacer',
      'mode': 'Des thèmes',
      'dark': 'Foncé',
      'regular': 'Ordinaire',
      'system': 'Système',
    },

    'de': {
      'title': 'Musikspieler',
      'music': 'Musik',
      'playlist': 'Wiedergabeliste',
      'settings': 'die Einstellungen',
      'playing': 'Läuft gerade',
      'search': 'Suche',
      'songs': 'Lieder',
      'albums': 'Alben',
      'ok': 'OK',
      'no playlist': 'Keine Wiedergabelisten gefunden',
      'no song': 'Kein Lied gefunden',
      'invalid': 'Bitte geben Sie den gültigen Namen ein',
      'cancel': 'Stornieren',
      'create': 'Erstellen',
      'added': 'hinzugefügt',
      'already': 'existiert bereits in',
      'enter': 'Name eingeben',
      'select': 'Wählen Sie Wiedergabeliste',
      'results': 'Ergebnisse für',
      'delete': 'Löschen',
      'mode': 'Themen',
      'dark': 'Dunkel',
      'regular': 'Regulär',
      'system': 'System',
    },

    'ru': {
      'title': 'Музыкальный проигрыватель',
      'music': 'Музыка',
      'playlist': 'Playlist',
      'settings': 'настройки',
      'playing': 'Сейчас играет',
      'search': 'Поиск',
      'songs': 'песни',
      'albums': 'Альбомы',
      'ok': 'ОК',
      'no playlist': 'Плейлистов не найдено',
      'no song': 'Не найдено ни одной песни',
      'invalid': 'Введите действительное имя',
      'cancel': 'Отмена',
      'create': 'Создайте',
      'added': 'добавленной',
      'already': 'уже существует в',
      'enter': 'Введите имя',
      'select': 'Выбрать плейлист',
      'results': 'Результаты для',
      'delete': 'Удалить',
      'mode': 'Темы',
      'dark': 'Темно',
      'regular': 'регулярное',
      'system': 'система',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get music{
    return _localizedValues[locale.languageCode]['music'];
  }

  String get playlist{
    return _localizedValues[locale.languageCode]['playlist'];
  }

  String get settings{
    return _localizedValues[locale.languageCode]['settings'];
  }

  String get nowPlaying{
    return _localizedValues[locale.languageCode]['playing'];
  }

  String get search{
    return _localizedValues[locale.languageCode]['search'];
  }

  String get songs{
    return _localizedValues[locale.languageCode]['songs'];
  }

  String get albums{
    return _localizedValues[locale.languageCode]['albums'];
  }

  String get ok{
    return _localizedValues[locale.languageCode]['ok'];
  }

  String get noSong{
    return _localizedValues[locale.languageCode]['no song'];
  }

  String get noPlaylist{
    return _localizedValues[locale.languageCode]['no playlist'];
  }

  String get invalidName{
    return _localizedValues[locale.languageCode]['invalid'];
  }

  String get cancel{
    return _localizedValues[locale.languageCode]['cancel'];
  }

  String get create{
    return _localizedValues[locale.languageCode]['create'];
  }

  String get added{
    return _localizedValues[locale.languageCode]['added'];
  }

  String get already{
    return _localizedValues[locale.languageCode]['already'];
  }

  String get enter{
    return _localizedValues[locale.languageCode]['enter'];
  }

  String get select{
    return _localizedValues[locale.languageCode]['select'];
  }

  String get results{
    return _localizedValues[locale.languageCode]['results'];
  }

  String get delete{
    return _localizedValues[locale.languageCode]['delete'];
  }

  String get dark{
    return _localizedValues[locale.languageCode]['dark'];
  }

  String get regular{
    return _localizedValues[locale.languageCode]['regular'];
  }

  String get system{
    return _localizedValues[locale.languageCode]['system'];
  }

  String get mode{
    return _localizedValues[locale.languageCode]['mode'];
  }

}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es', 'fr', 'de', 'ru'].contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) {
    return SynchronousFuture<MyLocalizations>(MyLocalizations(locale));
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}