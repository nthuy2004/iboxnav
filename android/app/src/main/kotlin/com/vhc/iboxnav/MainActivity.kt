package com.vhc.iboxnav

import android.os.Bundle
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import android.util.Log;
import com.google.android.gms.maps.MapsInitializer
import com.google.android.gms.maps.MapsInitializer.Renderer
import com.google.android.gms.maps.OnMapsSdkInitializedCallback


class MainActivity: FlutterActivity(), OnMapsSdkInitializedCallback {
    override 
    fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState);
        //MapsInitializer.initialize(applicationContext, Renderer.LEGACY, this)
    }

    override fun onMapsSdkInitialized(renderer: MapsInitializer.Renderer) {
      when (renderer) {
        Renderer.LATEST -> Log.d("NewRendererLog", "The latest version of the renderer is used.")
        Renderer.LEGACY -> {
          Log.d("NewRendererLog","The legacy version of the renderer is used.")
          Toast.makeText(applicationContext, "The legacy version of the renderer is used. Crashing may be appear !", Toast.LENGTH_SHORT).show()
        }
      }
    }
}
