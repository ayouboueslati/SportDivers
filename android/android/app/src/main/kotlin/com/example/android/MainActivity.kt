package com.example.android

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AppCenter.start(application, "5d6d517a-f682-404f-aefe-c22577cb8db6", Analytics::class.java, Crashes::class.java)
    }
}