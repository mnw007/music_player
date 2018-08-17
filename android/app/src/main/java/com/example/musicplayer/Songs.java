package com.example.musicplayer;

import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

class Songs {

  private String title;
  private String data;
  private String album;
  private String artist;
  private String albumArt;
  private String duration;

    Songs(String title,String data,String album,String artist,String albumArt,String duration){
        this.title= title;
        this.data= data;
        this.album= album;
        this.artist= artist;
        this.albumArt= albumArt;
        this.duration= duration;
    }

    public JSONObject getJSONObject() {
        JSONObject obj = new JSONObject();
        try {
            obj.put("Title", title);
            obj.put("Data", data);
            obj.put("Album", album);
            obj.put("Artist", artist);
            obj.put("AlbumArt", albumArt);
            obj.put("Duration", duration);
        } catch (JSONException e) {
            Log.e("error","DefaultListItem.toString JSONException: "+e.getMessage());
        }
        return obj;
    }
}

