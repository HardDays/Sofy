package com.enjoysofy.app;

import androidx.annotation.NonNull
import com.enjoysofy.app.plugin.VibrationPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        VibrationPlugin.registerWith(flutterEngine, context);
    }



}
