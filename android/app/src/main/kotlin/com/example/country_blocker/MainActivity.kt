package com.example.country_blocker

import android.app.role.RoleManager
import android.content.Context
import android.content.Intent
import android.os.Build
// import android.telecom.TelecomManager // If needed for older APIs
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.country_blocker/channel"
    private val REQUEST_ID = 1

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestRole" -> {
                    requestCallScreeningRole()
                    result.success(true)
                }
                "checkRole" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        val roleManager = getSystemService(Context.ROLE_SERVICE) as RoleManager
                        val isHeld = roleManager.isRoleHeld(RoleManager.ROLE_CALL_SCREENING)
                        result.success(isHeld)
                    } else {
                        // For older versions, we might standardly return true or check default dialer
                        // But since we target blocking which requires this role/service, let's return false or handle gracefully
                        // For now, assuming Q+ for this specific feature as per BlockingService requirement
                        result.success(true) 
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun requestCallScreeningRole() {
        android.util.Log.d("CountryBlocker", "Requesting Call Screening Role. SDK: ${Build.VERSION.SDK_INT}")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = getSystemService(Context.ROLE_SERVICE) as RoleManager
            val isAvailable = roleManager.isRoleAvailable(RoleManager.ROLE_CALL_SCREENING)
            val isHeld = roleManager.isRoleHeld(RoleManager.ROLE_CALL_SCREENING)
            
            android.util.Log.d("CountryBlocker", "Role Available: $isAvailable, Role Held: $isHeld")

            if (isAvailable) {
                if (isHeld) {
                    android.util.Log.d("CountryBlocker", "Role already held")
                    return
                }
                android.util.Log.d("CountryBlocker", "Launching role request intent")
                val intent = roleManager.createRequestRoleIntent(RoleManager.ROLE_CALL_SCREENING)
                startActivityForResult(intent, REQUEST_ID)
            } else {
                android.util.Log.e("CountryBlocker", "Role Call Screening is NOT available on this device")
            }
        } else {
             android.util.Log.w("CountryBlocker", "Android version below Q (29), cannot request ROLE_CALL_SCREENING via RoleManager")
             // Here we might need to fallback to asking to be Default Dialer for older phones, 
             // but for now just logging explains why it doesn't work.
        }
    }
}
