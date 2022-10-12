import 'dart:async';                                     // new
import 'package:firebase_auth/firebase_auth.dart'        // new
    hide EmailAuthProvider, PhoneAuthProvider;           // new
import 'package:firebase_core/firebase_core.dart';       // new
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';                 // new
import 'firebase_options.dart';                          // new
import 'src/authentication.dart';                        // new
import 'src/widgets.dart';

void main() async {
  /*
  https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in
  Fourth Example
  */
  WidgetsFlutterBinding.ensureInitialized();

  //authentication demo
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Start adding here
      initialRoute: '/home',
      routes: {
        '/home': (context) {
          return const HomePage();
        },
        '/sign-in': ((context) {
          return SignInScreen(
            actions: [
              ForgotPasswordAction(((context, email) {
                Navigator.of(context)
                    .pushNamed('/forgot-password', arguments: {'email': email});
              })),
              AuthStateChangeAction(((context, state) {
                if (state is SignedIn || state is UserCreated) {
                  var user = (state is SignedIn)
                      ? state.user
                      : (state as UserCreated).credential.user;
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                  }
                  if (!user.emailVerified) {
                    user.sendEmailVerification();
                    const snackBar = SnackBar(
                        content: Text(
                            'Please check your email to verify your email address'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              })),
            ],
          );
        }),
        '/forgot-password': ((context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return ForgotPasswordScreen(
            email: arguments?['email'] as String,
            headerMaxExtent: 200,
          );
        }),
        '/profile': ((context) {
          return ProfileScreen(
            providers: [],
            actions: [
              SignedOutAction(
                ((context) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }),
              ),
            ],
            children: <Widget>[
              Text(
              'You have clicked the button this many times:',
            ),
            Text(
              //'$_counter',
              'test',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Align(
              /*
              child: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Decrement',
              child: Icon(Icons.remove),
              ),
              */
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                /*
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _decrementCounter,
                    child: Icon(Icons.navigate_before),
                  ),
                  FloatingActionButton(
                    onPressed: _resetToZero,
                    child: Icon(Icons.radio_button_unchecked),
                  ),
                  FloatingActionButton(
                    onPressed: _incrementCounter,
                    child: Icon(Icons.navigate_next),
                  )
                ],
                */
              ),
            ),
            ],
          );
        })
      },
      // end adding here
      title: 'NMRA1',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.black,
            ),
        primarySwatch: Colors.blueGrey,
        // textTheme: GoogleFonts.robotoTextTheme(
        //   Theme.of(context).textTheme,
        // ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Flutter Demo 6 Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseDatabase database = FirebaseDatabase.instance;

  int _counter = 0;

  void _incrementCounter() async {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/" + _counter.toString());
    await ref.set({
      "name": "John",
      "age": _counter,
      "address": {
        "line1": "100 Mountain View"
      }
    });
  }

  void _decrementCounter() async {
    if(_counter > 0)
    {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/" + _counter.toString());
      await ref.remove();
      setState(() {
        // This call to setState tells the Flutter framework that something has
        // changed in this State, which causes it to rerun the build method below
        // so that the display can reflect the updated values. If we changed
        // _counter without calling setState(), then the build method would not be
        // called again, and so nothing would appear to happen.
        _counter--;
      });
    }
  }

  void _resetToZero() {
    setState(() {
      _counter=0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title!),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have clicked the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Align(
              /*
              child: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Decrement',
              child: Icon(Icons.remove),
              ),
              */
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _decrementCounter,
                    child: Icon(Icons.navigate_before),
                  ),
                  FloatingActionButton(
                    onPressed: _resetToZero,
                    child: Icon(Icons.radio_button_unchecked),
                  ),
                  FloatingActionButton(
                    onPressed: _incrementCounter,
                    child: Icon(Icons.navigate_next),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      */

      /*
      // Buttons on bottom
      floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _decrementCounter,
                  child: Icon(Icons.navigate_before),
                ),
                FloatingActionButton(
                  onPressed: _resetToZero,
                  child: Icon(Icons.radio_button_unchecked),
                ),
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  child: Icon(Icons.navigate_next),
                )
              ],
            ),
          )
        */

    );
  }
}
*/

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        //FirebaseDatabase database = FirebaseDatabase.instance;
        // DatabaseReference ref = FirebaseDatabase.instance.ref("users/" + user.email.toString().replaceAll('.', '_dot_'));
        //     ref.set({
        //       "name": "John",
        //       "email": user.email.toString(),
        //       "address": {
        //         "line1": "100 Mountain View"
        //       }
        //     });
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Title: NMRA'),
        ),
        body: ListView(
          children: <Widget>[
            //Image.asset('assets/codelab.png'),
            const SizedBox(height: 8),
            const IconAndDetail(Icons.train, 'NMRA'),
            Consumer<ApplicationState>(
              builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }
              ),
            ),
            const Divider(
              height: 8,
              thickness: 1,
              indent: 8,
              endIndent: 8,
              color: Colors.grey,
            ),
          ],
        ),
      )
    );
  }
}
