package com.example.musicplayer;

import android.Manifest;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.os.Bundle;
import android.provider.MediaStore;
import androidx.core.app.ActivityCompat;
import android.util.Log;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "music_player/songsUri";
    String songs;
    JSONArray jsonArray;
    Result result1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {

                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        if (call.method.equals("getSongs")) {
                            result1 = result;
                            requestPermissions();

                           /* if (songs != null) {
                                result.success(songs);
                            } else {
                                result.error("UNAVAILABLE", "Songs are not available.", null);
                            }*/
                        } else {
                            result.notImplemented();
                        }
                    }
                });
    }

    void getSongs() {
        jsonArray = new JSONArray();
        ArrayList<Songs> musicPathArrList = new ArrayList<>();
        Cursor managedCursor = getContentResolver().query(
                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                new String[]{
                        MediaStore.Audio.Media.TITLE,
                        MediaStore.Audio.Media.DATA,
                        MediaStore.Audio.Media.ALBUM,
                        MediaStore.Audio.Media.ARTIST,
                        MediaStore.Audio.Media.ALBUM_ID,
                        MediaStore.Audio.Media.DURATION
                },
                null,
                null,
                MediaStore.Audio.Media.DEFAULT_SORT_ORDER
        );

        if (managedCursor != null && managedCursor.moveToFirst()) {

            Cursor cursorAlbum;
            do {
                Long albumId = Long.valueOf(managedCursor.getString(managedCursor.getColumnIndex(MediaStore.Audio.Media.ALBUM_ID)));
                cursorAlbum = getContentResolver().query(MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
                        new String[]{MediaStore.Audio.Albums._ID, MediaStore.Audio.Albums.ALBUM_ART},
                        MediaStore.Audio.Albums._ID + "=" + albumId, null, null);

                if (cursorAlbum != null && cursorAlbum.moveToFirst()) {
                    String albumArt = cursorAlbum.getString(cursorAlbum.getColumnIndex(MediaStore.Audio.Albums.ALBUM_ART));
                    String title = managedCursor.getString(managedCursor.getColumnIndex(MediaStore.Audio.Media.TITLE));
                    String data = managedCursor.getString(managedCursor.getColumnIndex(MediaStore.Audio.Media.DATA));
                    String album = managedCursor.getString(managedCursor.getColumnIndex(MediaStore.Audio.Media.ALBUM));
                    String artist = managedCursor.getString(managedCursor.getColumnIndex(MediaStore.Audio.Media.ARTIST));
                    String duration = managedCursor.getString(managedCursor.getColumnIndex(MediaStore.Audio.Media.DURATION));
                    musicPathArrList.add(new Songs(title, data, album, artist, albumArt, duration));
                }
            } while (managedCursor.moveToNext());
            cursorAlbum.close();
        }
        managedCursor.close();
        for (int i = 0; i < musicPathArrList.size(); i++) {
            jsonArray.put(musicPathArrList.get(i).getJSONObject());
        }
        songs = jsonArray.toString();
        if (result1 != null)
        {
            result1.success(songs);
        }
    }

    private void requestPermissions() {
        if (this.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(MainActivity.this, Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
                Toast.makeText(MainActivity.this, "Permission required", Toast.LENGTH_LONG).show();
                ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);

            } else {
                // No explanation needed; request the permission
                ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
            }
        } else {
            // Permission has already been granted
            getSongs();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        if (requestCode == 1)
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                getSongs();
            } else {
                Log.e("value", "Permission Denied, You cannot use local drive .");
            }
    }

}
