package com.example.android
import com.microsoft.appcenter.AppCenter;
import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.crashes.Crashes;
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        AppCenter.start(getApplication(), "5d6d517a-f682-404f-aefe-c22577cb8db6",
                  Analytics.class, Crashes.class);
        super.onCreate(savedInstanceState)
    }
}