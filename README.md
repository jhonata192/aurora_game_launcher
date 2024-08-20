### Aurora game launcher, a launcher for your games
### what is it?
Aurora game launcher is a launcher to download and update your chosen game or/application that is over 200mb due to 
[new google policy, 1. ](https://support.google.com/googleplay/android-developer/answer/9859152?hl=en#zippy=%2Cmaximum-size-limit)
[2](https://android-developers.googleblog.com/2023/11/power-your-growth-on-google-play.html)
[3](https://developer.android.com/guide/app-bundle?hl=pt-br)

We are providing a launcher that developers can modify to download their game or application over 200MB, regardless of size.
instead of needing to use the  
[Play Feature Delivery](https://developer.android.com/guide/app-bundle/dynamic-delivery?hl=pt-br)
and the
[Play Asset Delivery](https://developer.android.com/guide/app-bundle/asset-delivery?hl=pt-br)
or reduce the size of your code by cutting pieces of code or providing it through unity via continuous delivery, you can use our launcher to download, update your game!

### features
* download the game. Using a direct URL you can deliver your game without any problems.
* version checker. You can check the local and server versions for comparison and start updating the game.
* modification. You can modify the app name, logo, icons, texts, download URLS and much more!
New features are coming soon!
### Accessibility
Many game launchers lack accessibility, so we decided to change that by introducing via
[flutter](https://en.wikipedia.org/wiki/Flutter_(software))
Accessibility for screen readers! This means that visually impaired and blind people who use screen readers such as Google Talkback and Jieshuo can use games and apps produced with our launcher in an accessible way!
### how does it work?
* You must provide a fixed URL for your APK hosted on your own server or GitHub, you can create a repository for that too.
* you must provide a version file, version.txt which has the server version number, example: v0.1
This file must also be the direct URL, and every time there is an update you must just change the server version, in other words: change the file.
The local version will be updated according to the current server version.

you can check [main.dart](https://github.com/jhonata192/aurora_game_launcher/blob/main/lib/main.dart)
For more information
### starting
We will guide you to produce your own launcher in the steps below.
### step 1, downloading flutter and android studio
To modify it to your liking you need flutter for that.
Below is a step-by-step guide on how to download Flutter.
### downloading flutter for VSCode users
1. if you use VS code, follow the steps below, otherwise skip step 1.
2. download [flutter extension for VS code](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
3.VSCode instructions.
1. 
Launch VS Code.
2. 
To open the Command Palette, press Control+Shift+P.
3. 
In the Command Palette, type flutter.
4. 
Select Flutter: New Project.
5. 
VS Code prompts you to locate the Flutter SDK on your computer.
1. 
If you have the Flutter SDK installed, click Find SDK.
2. 
If you don't have the Flutter SDK installed, click Download SDK.
This option sends you the Flutter installation page if you have not installed Git for Windows as stated in the development tools prerequisites.
6. 
When prompted Which Flutter model? , ignore it. Press Esc. You can create a test project after checking your development configuration.
7. Download the Flutter SDK
1. 
When the Select folder for Flutter SDK dialog appears, choose where you want to install Flutter.
VS Code puts you in your user profile to get started. Choose a different location.
Consider %USERPROFILE% or C:\dev.
Notice
Do not install Flutter to a directory or path that meets one or both of the following conditions:
◦ The path contains special characters or spaces.
◦ The path requires elevated privileges.
For example, C:\Program Files fails in both conditions.
2. 
Click Clone Flutter.
When downloading Flutter, VS Code displays this pop-up notification:
Downloading the Flutter SDK. This may take a few minutes.
This download takes a few minutes. If you suspect that the download is stuck, click Cancel and then start the installation again.
3. 
When the Flutter download is complete, the Output panel will appear.
Checking Dart SDK version...
Downloading Dart SDK from the Flutter engine...
Expanding downloaded archive...
When successful, VS Code displays this pop-up notification:
Initializing the Flutter SDK. This may take a few minutes.
During startup, the Output panel displays the following:
Building flutter tool...
Running pub upgrade...
Resolving dependencies...
Got dependencies.
Downloading Material fonts...
Downloading Gradle Wrapper...
Downloading package sky_engine...
Downloading flutter_patched_sdk tools...
Downloading flutter_patched_sdk_product tools...
Downloading windows-x64 tools...
Downloading windows-x64/font-subset tools...
This process is also run flutter doctor -v. At this point in the procedure, ignore this output. Flutter Doctor may show errors that do not apply to this quickstart.
When Flutter installation is successful, VS Code will display this pop-up notification:
Do you want to add the Flutter SDK to PATH so it's accessible
in external terminals?
4. 
Click Add SDK to PATH.
When successful, a notification will appear:
The Flutter SDK was added to your PATH
5. 
VS Code may display a Google Analytics warning.
If you agree, click OK.
6. 
To enable flutter in all PowerShell windows:
1.Close and reopen all PowerShell windows.
2. Restart VS Code.
## downloading flutter for non-VSCode users, flutter SDK.
1. download [flutter SDK](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.0-stable.zip)
2. To install Flutter, download the Flutter SDK package from the archive, move the package to where you want to store it, and extract the SDK.
3. I recommend creating a folder in c:\SRC and then extracting it there.
4. put the c:\src\flutter\bin folder in the patch system environment variables
5. check in powershell or CMD by typing flutter doctor to check if everything is ok.

### installing android studio, required for flutter.
1. Download the [latest version of Android Studio](https://developer.android.com/studio?hl=pt-br)
2. install android studio in standard way.
3. After everything is finished, open Android Studio and create a basic project.
4. wait for the entire project to load
5. After loading the entire project, press CTRl + ALT + S and you will be in the settings.
6. Go to Android SDK
7. Navigate to SDK tools and check android cmd line tools.
then accept everything, press ok and wait for it to install.
8. After everything is installed, close Android Studio. You'll be ready to make your own launcher.
### Step 2. cloning the project
There are several ways to clone the aurora game launcher.
1. via [git](https://git-scm.com/downloads)
2. [GitHub desktop](https://desktop.github.com/download/)
Choose the best way to clone the project.
### cloning instructions.
You can clone as follows
1. Clone using web URL.
https://github.com/jhonata192/aurora_game_launcher.git
2. the GitHub cli tool, GHcli.
gh repo clone jhonata192/aurora_game_launcher
3. you can download the [source code](https://codeload.github.com/jhonata192/aurora_game_launcher/zip/refs/heads/main)

### starting.
You can start producing your project as follows.
1. create a folder with the name of your application and move the entire cloned project there
### modifying
Let's start modifying [main.dart](https://github.com/jhonata192/aurora_game_launcher/blob/main/lib/main.dart)
To include your version URL and your game/app URL.
Modify the following attributes.
1. String gameUrl = '';
and
2. String versionUrl = '';
* Explanation
String gameUrl = ''; This is where you should place your APK URL for the game/application of your choice, usually hosted on a server or GitHub repository.
and
String versionUrl = ''; This is where you should place the URL of the server version normally hosted on your own server or GitHub repository.
* String currentVersion = 'v0.1';
This is the local version, it is recommended to leave the default but you can modify it as you wish. 
PS: if you are going to modify the local version, make sure the server version follows the same pattern.
* To modify application name/window title find the following attribute and modify
        title: Text('Game Launcher'),
* to modify what comes under the application name, find the following attribute and modify it.
           Text(
              'Welcome to Game Launcher',
* These are the modifications you must make to the code.
### completing the modification
After modifying the code, we imagine that you will want to enter the name of your own application, your own version, among other information.
Follow the guide below to make it simple!
### modifying metadata
first change in [pubspec.yaml](https://github.com/jhonata192/aurora_game_launcher/blob/main/pubspec.yaml)
lines 1, 19
* Line 1, name: 
* line 19, version: 1.0.0+0

then android/app/
file [build.gradle](https://github.com/jhonata192/aurora_game_launcher/blob/main/android/app/build.gradle)
line 9, 24
* Line 9, namespace = "com.name.package"
* line 24, applicationId = "com.package.name"

then android/app/src/main
file
 [AndroidManifest.xml](https://github.com/jhonata192/aurora_game_launcher/blob/main/android/app/src/main/AndroidManifest.xml)

line 9, android:label="your-APP-name"

then android/app/src/main/[kotlin/](https://github.com/jhonata192/aurora_game_launcher/tree/main/android/app/src/main/kotlin/)
you must change the subfolders according to the package name, in the case of this project the subfolders were like this/name/of/your/package
after changing between them until you reach the file 

[MainActivity](https://github.com/jhonata192/aurora_game_launcher/blob/main/android/app/src/main/kotlin/com/aurora/launcher_game/MainActivity.kt)

open it and change line 1
Line 1, package com.package.name

### signing and compiling
To submit your application to the Google Playstore you need to sign it and generate a key.properties key for it.
Follow the steps below.
### Steps to Subscribe a Flutter App

#### 1. Creating an Upload Keystore

**On macOS or Linux:**

Run the command below in the terminal:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
-keysize 2048 -validity 10000 -alias upload
```

**On Windows:**

Open cmd and run the following command:

```cmd
keytool -genkey -v -keystore %userprofile%\upload-keystore.jks ^
-storetype JKS -keyalg RSA -keysize 2048 -validity 10000 ^
-alias upload
```

This command creates the `upload-keystore.jks` file in the user's home directory.

#### 2. Configuring the `key.properties` File

Create a file called key.properties in the `[project]/android/` directory with the following content:

```properties
storePassword=<password-from-previous-step>
keyPassword=<password-from-previous-step>
keyAlias=upload
storeFile=<keystore-file-location>
```

- Replace `<password-from-previous-step>` with the password provided during keystore creation.- Replace `<keystore-file-location>` with the full path to the `upload-keystore.jks` file. On macOS, for example, this could be `/Users/<user name>/upload-keystore.jks`, and on Windows, `C:\\Users\\<user name>\\upload-keystore.jks`.

#### 3. Subscription Configuration in Gradle

Edit the `build.gradle` file located at `[project]/android/app/` to configure app signing in release mode.

1. **Load Keystore Properties:**

   Add the following code before the `android` block:

   ```groovy
   def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }
   ```

2. **Subscription Setup:**

   Add the signature configuration before the `buildTypes` block:

   ```groovy
   signingConfigs {
       release {
           keyAlias ​​keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   
   buildTypes {
      release {
         signingConfig signingConfigs.release
      }
   }
   ```

#### 4. Finalization

Flutter is now configured to sign all release builds with the configured keystore.

**Observation:**  
After making changes to the `build.gradle` file, you may need to run `flutter clean` to prevent cached builds from interfering with the signing process.

By following these steps, your Flutter app will be correctly signed and ready for distribution.

### compiling
use the command below to compile the signed file in .aab

flutter build appbundle --release

The .aab file will be found in /your-project/build/outputs/bundle/release
### Verifying the signature
You may want to check if your APP has actually been signed with your signing key, for this you can use [virustotal](https://www.virustotal.com/)
Click on file and choose your .aab file
Then, on the details tab, check the certificate details
A basic example might be [like this](https://www.virustotal.com/gui/file/347f8a227f99fbcec5b6b12d2ee9f0b841e4c933bd8fef8d4c874d4aea1a5a8c/details)
### known issues
* you may need to add the JDK system variables to sign your application
* Flutter only accepts directories without space, this means your SDK has to be placed in a parent directory
* every time you have to update the application you will need to change the server version, version.txt located on the server, not the direct URL of the APK this remains intact
### credits and thanks
* juan, [azurejoga](https://github.com/azurejoga/) for the documentation
* Jhonata Fernandes, [masterJF, 1](https://masterjf-solucoes.com.br/)
[2](https://github.com/jhonata192)
By project code and structure
### contributing
For those who want to contribute, welcome to open an [issue](https://github.com/jhonata192/aurora_game_launcher/issues) or a 
[PR](https://github.com/jhonata192/aurora_game_launcher /pulls)