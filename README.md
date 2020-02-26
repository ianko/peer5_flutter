![Pub Version](https://img.shields.io/pub/v/peer5?style=for-the-badge)

# Peer5 Flutter

Flutter plugin to integrate with the Peer5 native SDKs on Android and iOS.

## Getting Started

You will need some steps to install and configure this plugin properly.

### Step 1: Obtain an API KEY

Register at https://app.peer5.com/register and retrieve the `CustomerID` (aka `API KEY`) in the `Account` page.

### Step 2: Install the plugin

In your `pubspec.yaml` file, add the `peer5` dependency. [Read this page for more information and version number.](https://pub.dev/packages/peer5#-installing-tab-)

Don't forget to run `pod install` inside the `ios/` directory.

### Step 3: Configure iOS and Android

### On iOS

Add your `CustomerID` and, in order to allow the loading of distributed content via the Peer5 proxy, enable loading data from HTTP in your app by opening your `Info.plist` file as source code and adding the following values below the `</dict>` tag:

```xml
<key>Peer5ApiKey</key>
<string>Your-CustomerID-Goes-Here</string>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

#### On Android

Add this metadata tag to your `android/app/src/main/AndroidManifest.xml` inside the `<application>` tag after all activities:

```xml
<meta-data
    android:name="com.peer5.ApiKey"
    android:value="__YOUR_PEER5_TOKEN__" />
```

Starting Android 9 HTTP traffic is disabled by default. read more about this change [here](https://developer.android.com/training/articles/security-config#CleartextTrafficPermitted).

Without allowing HTTP for `127.0.0.1` this error might show up when trying to play: "Cleartext HTTP traffic to 127.0.0.1 not permitted."

Create file in `android/app/src/main/res/xml/network_security_config.xml` with content:

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">127.0.0.1</domain>
    </domain-config>
</network-security-config>
```

In `android/app/src/main/AndroidManifest.xml` add the `android:networkSecurityConfig="@xml/network_security_config"` attribute to the `<application>` tag:

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest>
    <uses-permission android:name="android.permission.INTERNET" />
    <application
        android:networkSecurityConfig="@xml/network_security_config">

    </application>
</manifest>
```

### Step 4: Usage

On iOS, you will need to initialize the local server by calling `Peer5.init();`. The instance should be bound to the application's lifetime and be initialized just once.

You can initialize anytime, but I recommend doing it at an early stage of the app initialization. In the `initState()` of the first widget, or even on the `main()` function (Just remember to add the `WidgetsFlutterBinding.ensureInitialized();` in this case).

On Android, the Peer5 native SDK already starts the server for you. Calling `Peer5.init();` on Android is safe and won't have any effect, so you don't need to add any conditional for it.

When initializing the `VideoPlayerController` instance, you will pass the proxied url that Peer5 will provide by calling `Peer5.getStreamUrl(url)` first.

```dart
final originalVideoUrl = 'http://cbsnewshd-lh.akamaihd.net/i/CBSNHD_7@199302/master.m3u8';
final proxiedUrl = await Peer5.getStreamUrl(originalVideoUrl);

// use the url passing through Peer5's local server
final videoController = VideoPlayerController.network(proxiedUrl);
```

#### Full example:

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:peer5/peer5.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _streamUrl;

  @override
  void initState() {
    super.initState();
    Peer5.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getStreamUrl() async {
    _streamUrl = await Peer5.getStreamUrl(
        'http://cbsnewshd-lh.akamaihd.net/i/CBSNHD_7@199302/master.m3u8',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Video Player')),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          height: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: _getStreamUrl,
                child: const Text('GET STREAM URL'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                elevation: 30.0,
              ),
              Divider(),
              if (_streamUrl != null) Text(_streamUrl),
            ],
          ),
        ),
      ),
    );
  }
}
```

*That’s all that’s needed for you to get started!*

For more information, read the official documentation:

(iOS) https://docs.peer5.com/platforms/ios/

(Android) https://docs.peer5.com/platforms/android/

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details