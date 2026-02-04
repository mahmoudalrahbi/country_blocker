package com.example.country_blocker

import android.content.Context
import android.telecom.Call
import android.telecom.CallScreeningService
import android.util.Log
import org.json.JSONObject

class CallBlockingService : CallScreeningService() {

    override fun onScreenCall(callDetails: Call.Details) {
        val phoneNumber = callDetails.handle?.schemeSpecificPart ?: return
        
        // Clean number (remove non-digits usually, but keep +)
        // Usually implementation should robustly handle formats
        
        if (shouldBlock(phoneNumber)) {
            Log.d("CountryBlocker", "Blocking call from: $phoneNumber")
            val response = CallResponse.Builder()
                .setDisallowCall(true)
                .setRejectCall(true)
                .setSkipCallLog(false)
                .setSkipNotification(true)
                .build()
            
            respondToCall(callDetails, response)
        } else {
            val response = CallResponse.Builder()
                .setDisallowCall(false) // Allow
                .build()
            respondToCall(callDetails, response)
        }
    }

    private fun shouldBlock(number: String): Boolean {
        // Read directly from Shared Preferences used by Flutter
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        
        // Flutter shared_preferences keys are prefixed with "flutter."
        // We use the simplified JSON string key for native access
        val blockedJsonString = prefs.getString("flutter.blocked_countries_simple", null) ?: return false
        
        try {
            // It's a JSON Array of objects
            val jsonArray = org.json.JSONArray(blockedJsonString)
            for (i in 0 until jsonArray.length()) {
                val item = jsonArray.getJSONObject(i)
                val code = item.getString("phoneCode")
                
                // number format: usually "+971..." or "00971..."
                // We check if number starts with "+" + code or "00" + code
                // or just contains it at start.
                
                if (number.startsWith("+$code") || number.startsWith("00$code")) {
                    return true
                }
                
                // Also handle cases where number has no +, just digits, but implies country code?
                // E.g. 1555...
                if (number.startsWith(code)) {
                     // CAREFUL: blocking "1" blocks US, but "1" is also start of "12" (meaningless example)
                     // If code is "1", and number is "1555...", it blocks.
                     return true
                }
            }
        } catch (e: Exception) {
            Log.e("CountryBlocker", "Error parsing blocked list", e)
        }

        return false
    }
}
