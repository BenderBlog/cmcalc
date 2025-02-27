// Copyright 2025 BenderBlog Rodriguez
// SPDX-License-Identifier: GPL-2.0-or-later

package io.github.benderblog.cmcalc

import CalculatorWrapper
import android.system.Os.setenv
import android.system.Os.getenv
import android.util.Log
import com.jherkenhoff.libqalculate.Calculator
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

//val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "settings")

class MainActivity: FlutterActivity() {
    init {
        setenv("LANG","zh_CN.UTF-8",true)
        Log.i("cmcalc-native", ": ${getenv("LANG")}")
        System.loadLibrary("qalculate_swig")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val api = CalculatorBridge(Calculator())
        CalculatorWrapper.setUp(flutterEngine.dartExecutor.binaryMessenger, api)
        CalendarWrapper.setUp(flutterEngine.dartExecutor.binaryMessenger, CalendarBridge())
    }
}