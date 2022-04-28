package com.example.background_sms_test

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import be.tramckrijte.workmanager.WorkmanagerPlugin
import com.juliusgithaiga.flutter_sms_inbox.FlutterSmsInboxPlugin

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        WorkmanagerPlugin.setPluginRegistrantCallback(this)
        //FlutterSmsInboxPlugin.setPluginRegistrantCallback(this)
    }

    override fun registerWith(registry: PluginRegistry) {
        WorkmanagerPlugin.registerWith(registry?.registrarFor("be.tramckrijte.workmanager.WorkmanagerPlugin"))
        FlutterSmsInboxPlugin.registerWith(registry?.registrarFor("com.juliusgithaiga.flutter_sms_inbox.FlutterSmsInboxPlugin"))
    }
}