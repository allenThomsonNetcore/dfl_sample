package com.example.sampleapp_bfdl

import android.util.Log
import com.netcore.android.Smartech
import io.flutter.app.FlutterApplication
import java.lang.ref.WeakReference
import com.netcore.smartech_base.SmartechBasePlugin
import com.netcore.smartech_push.SmartechPushPlugin

class MyApplication : FlutterApplication(){
    override fun onCreate() {
        super.onCreate()

        // Initialize Smartech Sdk
        Smartech.getInstance(WeakReference(applicationContext)).initializeSdk(this)
        // Add the below line for debugging logs
        Smartech.getInstance(WeakReference(applicationContext)).setDebugLevel(9)
        // Add the below line to track app install and update by smartech
        Smartech.getInstance(WeakReference(applicationContext)).trackAppInstallUpdateBySmartech()

        // Initialize Flutter Smartech Base Plugin
        SmartechBasePlugin.initializePlugin(this)
        SmartechPushPlugin.initializePlugin(this)

    }

    override fun onTerminate() {
        super.onTerminate()
        Log.d("onTerminate", "onTerminate")
    }
}