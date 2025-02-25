package io.github.jumperonjava.spintrick

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.media.MediaPlayer
import android.util.Log
import java.time.Instant
import java.util.Date
import kotlin.math.abs
import kotlin.math.sign
import kotlin.time.TimeSource

class SpinService(private val context: Context) : SensorEventListener {
    private val sensorManager: SensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

    private var player: MediaPlayer? = null
    private var comboPlayer: MediaPlayer? = null
    private var silentPlayer: MediaPlayer? = null

    private var totalRotation = 0.0
    private var combo = 0.0

    fun init() {
        val gyroSensor = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
        if (gyroSensor != null) {
            sensorManager.registerListener(this, gyroSensor, SensorManager.SENSOR_DELAY_UI)
        }

        player = MediaPlayer.create(context, R.raw.sound)
        comboPlayer = MediaPlayer.create(context, R.raw.combosound)
        silentPlayer = MediaPlayer.create(context, R.raw.silent)
    }

    private var prevspin: TimeSource.Monotonic.ValueTimeMark? = null;

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null) return
        if (prevspin == null) {
            prevspin = TimeSource.Monotonic.markNow();
            return;
        }

        val delta = (TimeSource.Monotonic.markNow().minus(prevspin!!).inWholeMilliseconds/1000f);
        prevspin = TimeSource.Monotonic.markNow();

        val rotationRateZ = event.values[2] * delta * 57.29
        totalRotation += rotationRateZ

        Log.i("spintrck","spin: ${rotationRateZ/delta}; delta: $delta")

        if (abs(rotationRateZ) < 45) {
            if (combo == 0.0) {
                combo = sign(totalRotation)
            }
            if (abs(totalRotation) > 270) {
                if (sign(totalRotation) == combo) {
                    player?.start()
                }
            }
            totalRotation = 0.0
        }
        silentPlayer?.start()
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    fun cleanup() {
        sensorManager.unregisterListener(this)
        player?.release()
        comboPlayer?.release()
        silentPlayer?.release()
    }
}