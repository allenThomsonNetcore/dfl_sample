import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sampleapp_bfdl/SplashScreen.dart';
import 'package:smartech_base/smartech_base.dart';
import 'package:smartech_push/smartech_push.dart';

import 'LoginScreen.dart';
import 'MainScreen.dart';
import 'ProfileScreen.dart';

// For background/terminated state
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  bool isFromSmt = await SmartechPush().isNotificationFromSmartech(message.data.toString());
  if(isFromSmt){
    SmartechPush().handlePushNotification(message.data.toString());
    return;
  }
  // handle if not from Smartech
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Register the background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  final androidToken = await FirebaseMessaging.instance.getToken();
  if (androidToken != null) {
    SmartechPush().setDevicePushToken(androidToken);
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    bool isFromSmt = await SmartechPush().isNotificationFromSmartech(message.data.toString());
    if(isFromSmt){
      SmartechPush().handlePushNotification(message.data.toString());
      return;
    }
    // handle if not from Smartech
  });

  Smartech().onHandleDeeplink((String? smtDeeplinkSource, String? smtDeeplink, Map<dynamic, dynamic>? smtPayload, Map<dynamic, dynamic>? smtCustomPayload) async {
      print('deeplinkfromthepanel'+smtDeeplink.toString());
       if (smtDeeplink != null && smtDeeplink.contains("profile")) {
Future.delayed(Duration(seconds: 2), () {
    navigatorKey.currentState?.pushNamed('/profile');
  });  }
});
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}