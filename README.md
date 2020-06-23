# website_blocker
 A Powershell script to easily block and unblock websites in Windows.


## Purpose
Though there are many website blocking extensions for both Firefox and Chrome, they require minimal effort to circumvent if you know what you're doing (e.g., use a different browser, use an incognito window). We needed a stronger (read: more annoying to circumvent) solution that was browser agnostic to keep us productive, but didn't want to pay for a GUI that basically does the same thing as this PowerShell script. 


## How It Works
By modifying your `C:\Windows\System32\drivers\etc\hosts` file, we reroute any outbound requests for `<website you'd like to block>` to your local machine's IP address (127.0.0.1). This prevents you from accessing `<website you'd like to block>` and harmlessly throws a `ERR_CONNECTION_REFUSED` without affecting the rest of your browsing experience. Websites can be unblocked by running the included `Unblock-Website` function, or by manually deleting the added line in your `hosts` file.

Important note: `Block-Website` clears your Chrome browser's cache to trigger the DNS lookup in `/hosts`. Other browsers may require you to manually clear your cache before this trick will start to work.


 ## Usage
 1. Run Powershell as an admin in Windows
    1. Press the "Windows key"
    2. Type "Powershell"
    3. Right-click the app and click "Run as administrator"
 2. Import the functions into your Powershell using `Import-Module <your file path here>\website_blocker.ps1`
 3. Type `Block-Website -url <website you'd like to block>` to block a website, close chrome, and clear your cache (example: `Block-Website -url reddit.com`). You can use the up-arrow to quickly block multiple websites.
 4. Type `Unblock-Website -url <website you'd like to unblock>` to resume access to a given website.


## Troubleshooting
1. If you're using a browser other than Chrome, did you reset your cache?
2. Are you sure you're blocking the right url? For example, if you want to block reddit.com, you may also need to try different prefixes:
   - `Block-Website -url www.reddit.com`
   - `Block-Website -url https://reddit.com`
3. Does your `C:\Windows\System32\drivers\etc\hosts` file look something like this?
   - ![example of a hosts file](./example.jpg)



## Potential Improvements
- Auto-clear Firefox's cache
- Suggest additional URLs to block based on browsing history (youtube.com -> m.youtube.com)
- Hide the boolean returns from CloseMainWindow()