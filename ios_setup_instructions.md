# iOS Call Directory Extension Setup

To enable call blocking on iOS, you must add a **Call Directory Extension** target to your Xcode project. This cannot be done fully automatically from the command line.

## Steps

1. **Open the Project in Xcode**
   - Run `open ios/Runner.xcworkspace` in your terminal.

2. **Add a New Target**
   - Go to **File > New > Target**.
   - Select **Call Directory Extension**.
   - Name it `CallDirectoryHandler`.
   - Ensure the language is **Swift**.
   - Value for "Project" and "Embed in Application" should be `Runner`.

3. **Configure App Groups (Crucial)**
   - To share the blocked list between the Flutter app and the Extension, you must use App Groups.
   - Select the `Runner` target -> **Signing & Capabilities** -> **+ Capability** -> **App Groups**.
   - Create a new group, e.g., `group.com.example.callshield`.
   - Select the `CallDirectoryHandler` target -> **Signing & Capabilities** -> **+ Capability** -> **App Groups**.
   - specific the **same** group (`group.com.example.callshield`).

4. **Update `CallDirectoryHandler.swift`**
   - Replace the content of the generated `CallDirectoryHandler.swift` with logic to read from the App Group's `UserDefaults`.
   
   ```swift
   import Foundation
   import CallKit

   class CallDirectoryHandler: CXCallDirectoryProvider {
       override func beginRequest(with context: CXCallDirectoryExtensionContext) {
           context.delegate = self
           
           // Create a shared UserDefaults container
           // Note: You must use the EXACT App Group ID you created
           if let userDefaults = UserDefaults(suiteName: "group.com.example.callshield") {
               if let blockedNumbers = userDefaults.array(forKey: "blocked_numbers") as? [Int64] {
                   for number in blockedNumbers.sorted() {
                       context.addBlockingEntry(withNextSequentialPhoneNumber: number)
                   }
               }
           }
           
           context.completeRequest()
       }
   }
   
   extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
       func request(_ request: CXCallDirectoryExtensionContext, didFailWithError error: Error) {
           // Handle error
       }
   }
   ```

5. **Update Flutter Code for iOS**
   - In Flutter, you need to save the numbers to the **App Group** UserDefaults, not standard `SharedPreferences`.
   - You might need a package like `shared_preferences_ios` or write a custom MethodChannel to write to `UserDefaults(suiteName: ...)`.
   - The current Android implementation uses `country_picker` and stores country codes. For iOS, you must expand these codes into actual phone numbers or ranges if possible (Limitation: CallKit requires exact numbers).
   
## Limitation Note
iOS CallKit generally blocks **exact phone numbers**. Blocking an entire country code (e.g. all numbers starting with +1) is not directly supported by the standard `addBlockingEntry` API unless you add all potential numbers (which is infeasible). 
Some advanced apps use large dictionaries of common spam numbers. 
**For this project, the Android implementation handles Country Blocking perfectly. The iOS implementation is limited by Apple's API design.**
