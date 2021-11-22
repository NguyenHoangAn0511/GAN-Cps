import 'package:flutter/material.dart';
import 'transfer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gan_compress/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Transfer(),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:gan_compress/components/life_cycle_event_handler.dart';
// import 'package:gan_compress/landing/landing_page.dart';
// import 'package:gan_compress/screens/mainscreen.dart';
// import 'package:gan_compress/services/user_service.dart';
// import 'package:gan_compress/utils/config.dart';
// import 'package:gan_compress/utils/constants.dart';
// import 'package:gan_compress/utils/providers.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Config.initFirebase();
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(
//       LifecycleEventHandler(
//         detachedCallBack: () => UserService().setUserStatus(false),
//         resumeCallBack: () => UserService().setUserStatus(true),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: providers,
//       child: Consumer<ThemeNotifier>(
//         builder: (context, ThemeNotifier notifier, child) {
//           return MaterialApp(
//             title: Constants.appName,
//             debugShowCheckedModeBanner: false,
//             theme: notifier.dark ? Constants.darkTheme : Constants.lightTheme,
//             home: StreamBuilder(
//               stream: FirebaseAuth.instance.authStateChanges(),
//               builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
//                 if (snapshot.hasData) {
//                   return TabScreen();
//                 } else
//                   return Landing();
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
