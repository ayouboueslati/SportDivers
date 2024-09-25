package com.ebuild.sportdivers

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AppCenter.start(application, "5d6d517a-f682-404f-aefe-c22577cb8db6", Analytics::class.java, Crashes::class.java)
    }
}
