package com.example.footballproject

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AppCenter.start(application, ""4ef81e71-8921-4b21-bf23-37b2fdee74fe"", Analytics::class.java, Crashes::class.java)
    }
}
