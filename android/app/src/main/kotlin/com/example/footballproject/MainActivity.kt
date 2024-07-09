package com.example.footballproject

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AppCenter.start(application, "222ea411-f9a0-4e97-9de7-6a159658240a", Analytics::class.java, Crashes::class.java)
    }
}
