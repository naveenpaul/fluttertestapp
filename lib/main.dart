import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'opportunity/opp_list_view.dart';
import 'opportunity/opp_sliver_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/login.dart';
// import 'package:provider/provider.dart';


// void main() => runApp(MyApp());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  MyApp({this.token});
  final String? token;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Relatas App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: (token == null || token!.isEmpty) ? LoginScreen() : BottomNavigationBarRecipe(
            title: 'BottomNavigationBarRecipe Demo', token: token),
        routes: <String, WidgetBuilder>{
          // '/login': (_) => new LoginScreen(),
          '/home': (_) => new OppSliverList(), // Home Page

        });
  }
}

class BottomNavigationBarRecipe extends StatefulWidget {
  BottomNavigationBarRecipe({Key? key, this.title, this.token})
      : super(key: key);

  final String? title;
  final String? token;

  @override
  _BottomNavigationBarRecipeState createState() =>
      _BottomNavigationBarRecipeState(token: this.token);
}

class _BottomNavigationBarRecipeState extends State<BottomNavigationBarRecipe> {
  _BottomNavigationBarRecipeState({this.token});

  String? token;
  int _page = 0;

  Widget bodyFunction() {
    switch (_page) {
      case 0:
        return OppSliverList();
        break;
      case 1:
      // return OppListView();
        return OppSliverList();
        break;
      case 2:
        return Container(color: Colors.orange);
        break;
      default:
        return Container(color: Colors.white);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var tcVisibility = (token == null || token!.isEmpty) ? false : true;

    print("tcVisibility--");
    print(tcVisibility);

    // if((token == null || token!.isEmpty)){
    //   return Scaffold(
    //     body:LoginScreen()
    //   );
    // } else {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: bodyFunction(),
        bottomNavigationBar: BottomAppBar(
            child: Row(
              children: <Widget>[
                // Bottom that pops up from the bottom of the screen.
                //   Expanded(
                //     child: IconButton(
                //     icon: Icon(Icons.home),
                //     onPressed: () {
                //       showModalBottomSheet<Null>(
                //         context: context,
                //         builder: (BuildContext context) => openBottomDrawer(),
                //       );
                //     },
                //   )
                // ),
                // Expanded(
                //     child: IconButton(
                //   icon: Icon(Icons.attach_money),
                //   onPressed: () {
                //     showModalBottomSheet<Null>(
                //       context: context,
                //       builder: (BuildContext context) => openBottomDrawer(),
                //     );
                //   },
                // )),
                //           Expanded(
                //             child: IconButton(
                //             icon: Icon(Icons.trending_up),
                //             onPressed: () {
                //               showModalBottomSheet<Null>(
                //                 context: context,
                //                 builder: (BuildContext context) => openCommitDrawer(),
                //                 );
                //               },
                //             )
                // ),
                //           Expanded(
                //             child: IconButton(
                //             icon: const Icon(Icons.forum),
                //             onPressed: () {
                //                 showModalBottomSheet<Null>(
                //                 context: context,
                //                 builder: (BuildContext context) => openDealRoomDrawer(),
                //                 );
                //               },
                //             ),
                // ),

                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      showModalBottomSheet<Null>(
                        context: context,
                        builder: (BuildContext context) => openProfileDrawer(),
                      );
                    },
                  ),
                )
              ],
            )),
      );
    // }
  }

  //This drawer is opened in modal bottom sheet
  Widget openBottomDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          //Add menu item to edit
          const ListTile(
            // leading: const Icon(Icons.add),
            title: const Text('Create Deal'),
          ),
          ListTile(
            //Add menu item to add a new item
            // leading: const Icon(Icons.),
              title: const Text('Analyse'),
              onTap: () {
                print("On analyse screen");
                setState(() {
                  _page = 1;
                });
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  Widget openDealRoomDrawer() {
    return Drawer(
      child: Column(
        children: const <Widget>[
          //Add menu item to edit
          const ListTile(
            // leading: const Icon(Icons.add),
            title: const Text('Create Deal Room'),
          ),
          const ListTile(
            //Add menu item to add a new item
            // leading: const Icon(Icons.),
            title: const Text('Rooms'),
          ),
        ],
      ),
    );
  }

  Widget openProfileDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          //Add menu item to edit
          // const ListTile(
          //   // leading: const Icon(Icons.add),
          //   title: const Text('Profile Settings'),
          // ),
          ListTile(
            //Add menu item to add a new item
            // leading: const Icon(Icons.),
            title: const Text('Logout'),
            onTap: () {
              SharedPreferences.getInstance().then((prefs) {
                prefs.remove("token");
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget openCommitDrawer() {
    return Drawer(
      child: Column(
        children: const <Widget>[
          //Add menu item to edit
          const ListTile(
            // leading: const Icon(Icons.add),
            title: const Text('Hard Commit'),
          ),
          const ListTile(
            //Add menu item to add a new item
            // leading: const Icon(Icons.),
            title: const Text('Analyse'),
          ),
          const ListTile(
            //Add menu item to add a new item
            // leading: const Icon(Icons.),
            title: const Text('Billing Commit'),
          ),
        ],
      ),
    );
  }
}