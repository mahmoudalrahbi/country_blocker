package com.example.country_blocker

import android.content.Context
import android.telecom.Call
import android.telecom.CallScreeningService
import android.telephony.TelephonyManager
import android.util.Log
import com.google.i18n.phonenumbers.PhoneNumberUtil
import com.google.i18n.phonenumbers.NumberParseException
import com.google.i18n.phonenumbers.Phonenumber
import java.util.Locale

class CallBlockingService : CallScreeningService() {

    override fun onScreenCall(callDetails: Call.Details) {
        val rawPhoneNumber = callDetails.handle?.schemeSpecificPart ?: return
        
        // Clean the number - some devices might send encoded chars
        val phoneNumber = java.net.URLDecoder.decode(rawPhoneNumber, "UTF-8")
        
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
        val blockedJsonString = prefs.getString("flutter.blocked_countries_simple", null) ?: return false
        
        val phoneUtil = PhoneNumberUtil.getInstance()
        var defaultRegion = "US" // Fallback
        
        // Try to get user's current region from SIM or Network
        try {
            val tm = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            val simCountry = tm.simCountryIso
            if (!simCountry.isNullOrEmpty()) {
                defaultRegion = simCountry.uppercase(Locale.getDefault())
            } else {
                val networkCountry = tm.networkCountryIso
                if (!networkCountry.isNullOrEmpty()) {
                    defaultRegion = networkCountry.uppercase(Locale.getDefault())
                }
            }
        } catch (e: Exception) {
            Log.e("CountryBlocker", "Error getting default region", e)
        }

        var incomingCountryCode = 0
        var isValidNumber = false
        
        try {
            // Parse using libphonenumber
            val phoneNumberProto: Phonenumber.PhoneNumber = phoneUtil.parse(number, defaultRegion)
            isValidNumber = phoneUtil.isValidNumber(phoneNumberProto)
            incomingCountryCode = phoneNumberProto.countryCode // e.g. 1, 971, 44
        } catch (e: NumberParseException) {
            Log.e("CountryBlocker", "Number parsing failed for: $number", e)
            // Fallback: If strict parsing fails, we cannot safely rely on code matching
            // We'll fallback to simple prefix check ONLY if it starts with '+'
            return fallbackCheck(number, blockedJsonString)
        }

        try {
            // Check against blocked list
            val jsonArray = org.json.JSONArray(blockedJsonString)
            for (i in 0 until jsonArray.length()) {
                val item = jsonArray.getJSONObject(i)
                val blockedCodeStr = item.getString("phoneCode") // "1", "971"
                
                // 1. Strict Code Match via LibPhoneNumber
                try {
                    val blockedCode = blockedCodeStr.toInt()
                    if (isValidNumber && incomingCountryCode == blockedCode) {
                        return true
                    }
                } catch (e: NumberFormatException) {
                    continue
                }
            }
        } catch (e: Exception) {
            Log.e("CountryBlocker", "Error parsing blocked list", e)
        }

        return false
    }
    
    // Fallback for when libphonenumber fails to parse (e.g. unknown format)
    private fun fallbackCheck(number: String, blockedJsonString: String): Boolean {
        try {
            val jsonArray = org.json.JSONArray(blockedJsonString)
            for (i in 0 until jsonArray.length()) {
                val item = jsonArray.getJSONObject(i)
                val code = item.getString("phoneCode")
                
                // Only match overly explicit prefixes to avoid "1" matching "12..."
                if (number.startsWith("+$code") || number.startsWith("00$code")) {
                    return true
                }
            }
        } catch (e: Exception) {
            // ignore
        }
        return false
    }
}
