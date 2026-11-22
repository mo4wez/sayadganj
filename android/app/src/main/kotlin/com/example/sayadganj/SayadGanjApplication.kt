package com.example.sayadganj

import android.app.Application
import android.content.Context
import android.content.res.Configuration
import java.util.Locale

class SayadGanjApplication : Application() {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(wrapRtlContext(base))
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        val rtlLocale = Locale("fa")
        resources.configuration.setLocale(rtlLocale)
        resources.configuration.setLayoutDirection(rtlLocale)
    }

    private fun wrapRtlContext(context: Context): Context {
        val rtlLocale = Locale("fa")
        Locale.setDefault(rtlLocale)
        val config = Configuration(context.resources.configuration)
        config.setLocale(rtlLocale)
        config.setLayoutDirection(rtlLocale)
        return context.createConfigurationContext(config)
    }
}