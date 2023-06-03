// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:uptrain/src/features/Website/Admin/controllers/MenuAppController.dart';
// import 'package:uptrain/src/features/Mobile/authentication/screens/login/login_screen.dart';
// import 'package:uptrain/src/features/Mobile/authentication/screens/welcome_screen/welcome_screen.dart';

// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
// await FirebaseMessaging.instance.requestPermission();

//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     final FirebaseMessaging messaging = FirebaseMessaging.instance;

//     messaging.getToken().then((value) => print('Token $value '));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // home: MainScreen(),
//       home: MultiProvider(
//         providers: [
//           ChangeNotifierProvider(
//             create: (context) => MenuAppController(),
//           ),
//         ],
//         child: LoginScreen(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uptrain/src/features/Mobile/authentication/screens/login/login_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) => print('Token $value '));

    // _configureFirebaseMessaging();
  }

  // void _configureFirebaseMessaging() {
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (message.notification != null) {
  //       print("Received message in foreground: ${message.notification!.title}");
  //       // Handle the notification data as per your requirement
  //     }
  //   });
  // }

  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   print("Handling a background message: ${message.messageId}");
  //   // Handle the notification data as per your requirement
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoginScreen());
  }
}
