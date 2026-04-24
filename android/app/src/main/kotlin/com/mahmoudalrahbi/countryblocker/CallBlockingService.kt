package com.mahmoudalrahbi.countryblocker

import android.content.Context
import android.net.Uri
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
        
        // Use Uri.decode instead of URLDecoder to preserve '+' 
        // (URLDecoder treats '+' as space)
        var phoneNumber = Uri.decode(rawPhoneNumber).trim()
        
        // Remove 'tel:' if present
        if (phoneNumber.startsWith("tel:")) {
            phoneNumber = phoneNumber.substring(4)
        }
        
        Log.d("CountryBlocker", "Incoming call detected: $phoneNumber")

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
            Log.d("CountryBlocker", "Allowing call from: $phoneNumber")
            val response = CallResponse.Builder()
                .setDisallowCall(false) // Allow
                .build()
            respondToCall(callDetails, response)
        }
    }

    private fun shouldBlock(number: String): Boolean {
         Log.e("CountryBlocker", "==============shouldBlock called with number: $number ==============")
        // Read directly from Shared Preferences used by Flutter
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        
        // 1. GLOBAL SWITCH CHECK
        // Default to true if not found to be safe, but app initializes it.
        val isGlobalBlockingEnabled = prefs.getBoolean("flutter.blocking_enabled", true)
        if (!isGlobalBlockingEnabled) {
            // If global switch is OFF, allow everything
             Log.e("CountryBlocker", "=====Global blocking is disabled. Allowing all calls.")
            return false
        }
        
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
        
        var phoneNumberProto: Phonenumber.PhoneNumber? = null
        
        try {
            // Parse using libphonenumber
            phoneNumberProto = phoneUtil.parse(number, defaultRegion)
            isValidNumber = phoneUtil.isValidNumber(phoneNumberProto)
            incomingCountryCode = phoneNumberProto.countryCode // e.g. 1, 971, 44
             Log.e("CountryBlocker", "=== incoming number parsed: countryCode=$incomingCountryCode, isValid=$isValidNumber, defaultRegion=$defaultRegion ===")
        } catch (e: NumberParseException) {
            Log.e("CountryBlocker", "Number parsing failed for: $number", e)
        }

        // IMPROVED FALLBACK:
        // If the number is NOT valid (or failed to parse initially) AND it doesn't accept a '+',
        // let's try to parse it again with a '+' prefix.
        // This handles cases like "1650..." coming in while in "OM" (Oman) region, where it's 
        // treated as a local number and fails validation.
        if (!isValidNumber && !number.startsWith("+")) {
             try {
                val numberPlus = "+$number"
                val potentialProto = phoneUtil.parse(numberPlus, null) // null region for international format
                 if (phoneUtil.isValidNumber(potentialProto)) {
                     phoneNumberProto = potentialProto
                     incomingCountryCode = phoneNumberProto.countryCode
                     isValidNumber = true
                     Log.e("CountryBlocker", "=== FIXED: Parsed with '+' prefix. CountryCode=$incomingCountryCode ===")
                 }
             } catch (e: Exception) {
                 Log.e("CountryBlocker", "Fallback '+' parsing failed", e)
             }
        }

        val cleanNumber = number.replace(Regex("\\D"), "")
        
        try {
            // Check against blocked list
            val jsonArray = org.json.JSONArray(blockedJsonString)
            for (i in 0 until jsonArray.length()) {
                val item = jsonArray.getJSONObject(i)
                
                // 2. PER-COUNTRY SWITCH CHECK
                val isRuleEnabled = if (item.has("isEnabled")) item.getBoolean("isEnabled") else true
                if (!isRuleEnabled) {
                    continue
                }
                
                val blockedCodeStr = item.getString("phoneCode")
                val cleanBlockedCode = blockedCodeStr.replace(Regex("\\D"), "")
                
                if (cleanBlockedCode.isEmpty()) continue
                
                // 3. MATCHING LOGIC
                
                // Case A: Strict Code Match via LibPhoneNumber
                // Even if the number is technically "invalid" (e.g. too long), 
                // if libphonenumber could extract the country code, we use it.
                var countryCodeMatched = false
                try {
                    val blockedCodeInt = cleanBlockedCode.toInt()
                    if (incomingCountryCode == blockedCodeInt && incomingCountryCode != 0) {
                        countryCodeMatched = true
                    }
                } catch (e: Exception) {}

                // Case B: Prefix Match (Fallback/Custom Rules)
                // This handles custom prefixes like "2439" or numbers where libphonenumber failed.
                val prefixMatched = cleanNumber.startsWith(cleanBlockedCode)
                
                if (countryCodeMatched || prefixMatched) {
                    var countryName = "Unknown"
                    if (phoneNumberProto != null) {
                        val regionCode = phoneUtil.getRegionCodeForNumber(phoneNumberProto)
                        if (regionCode != null) {
                            countryName = Locale("", regionCode).displayCountry
                        }
                    }
                    
                    val reportedCode = if (incomingCountryCode != 0) incomingCountryCode.toString() else cleanBlockedCode
                    saveBlockedCall(number, reportedCode, countryName, 3)
                    Log.e("CountryBlocker", "Blocked call matched: code=$cleanBlockedCode, country=$countryName")
                    return true
                }
            }
        } catch (e: Exception) {
            Log.e("CountryBlocker", "Error parsing blocked list", e)
        }

        return false
    }

    private fun saveBlockedCall(phoneNumber: String, countryCode: String, countryName: String, reason: Int) {
        try {
            val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val logsKey = "flutter.blocked_call_logs_native"
            
            // Get existing logs
            val existingJson = prefs.getString(logsKey, "[]")
            val jsonArray = org.json.JSONArray(existingJson)
            
            // Create new log entry
            val newLog = org.json.JSONObject()
            newLog.put("phoneNumber", phoneNumber)
            newLog.put("countryName", countryName) // We might not have this easily in native, will try best effort
            newLog.put("countryCode", countryCode)
            newLog.put("reason", reason)
            newLog.put("timestamp", java.time.ZonedDateTime.now().format(java.time.format.DateTimeFormatter.ISO_INSTANT))
            newLog.put("customReasonText", null)

            // Add to beginning of list (newest first)
            // JSONArray doesn't support adding at index 0 easily, so we might need to reconstruction
            // Or just add to end and sort in Flutter. Let's add to end for simplicity and sort in Flutter if needed,
            // but normally logs are append-only.
            // Actually, for "recent calls", we want newest first. 
            // Let's create a new array, add new item, then add all old items.
            val newArray = org.json.JSONArray()
            newArray.put(newLog)
            for (i in 0 until jsonArray.length()) {
                newArray.put(jsonArray.get(i))
            }
            
            // Limit log size (Optional, e.g. 100 items)
            // if (newArray.length() > 100) ...

            // Save back
            prefs.edit().putString(logsKey, newArray.toString()).apply()
            
        } catch (e: Exception) {
            Log.e("CountryBlocker", "Error saving blocked call log", e)
        }
    }
}
