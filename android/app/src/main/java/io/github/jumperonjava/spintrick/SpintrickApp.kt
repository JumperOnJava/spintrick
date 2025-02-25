package io.github.jumperonjava.spintrick

import android.app.Application
import android.util.Log
import java.util.logging.Logger

class SpintrickApp : Application() {
    override fun onCreate() {
        super.onCreate()
        Log.i("spintrick","created app");

    }
}