import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:wisata/login/view/login.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wisata/wisata/wisatapage.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  static const appTitle = 'Wisata';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String counter2 = '265';
  late SharedPreferences profileData;
  List _listsData = [];
  String nameU = '';
  String? name;
  String? role;
  String? email;
  String emailU = '';
  String addressU = '';
  Future<dynamic> ListUsersById() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var url = Uri.parse('${dotenv.env['url']}/me');
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      // print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print(data);
        setState(() {
          nameU = data['data'][0]['name'];
          emailU = data['data'][0]['email'];
          addressU = data['data'][0]['address'];
        });
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
    ListUsersById();
  }

  void initial() async {
    profileData = await SharedPreferences.getInstance();
    setState(() {
      name = profileData.getString('name');
      role = profileData.getString('role');
      email = profileData.getString('email');
    });
  }

  static final _client = http.Client();
  static final _logoutUrl = Uri.parse('${dotenv.env['url']}/logout');

  // ignore: non_constant_identifier_names
  Future Logout() async {
    try {
      EasyLoading.show(status: 'loading...');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      http.Response response = await _client.get(_logoutUrl, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      print(response.body);
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        setState(() {
          preferences.remove("id");
          preferences.remove("name");
          preferences.remove("email");
          preferences.remove("role");
          preferences.remove("token");
          preferences.remove("is_login");
        });
        EasyLoading.dismiss();
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showMyDialog(String title, String text, String nobutton,
      String yesbutton, Function onTap, bool isValue) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: isValue,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(nobutton),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(yesbutton),
              onPressed: () async {
                Logout();
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
          ],
        );
      },
    );
  }

  Future refresh() async {
    setState(() {
      ListUsersById();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              _showMyDialog('Log Out', 'Are you sure you want to logout?', 'No',
                  'Yes', () async {}, false);

              // ignore: unused_label
              child:
              Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              );
            },
          )
        ],
      ),
      body: const Center(
        child: ListWisataPage()
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('$name')),
            role == '1'
                ? Column(children: [
                    ListTile(
                      title: const Text('Home'),
                      selected: _selectedIndex == 0,
                      onTap: () {
                        // Update the state of the app
                        // _onItemTapped(0);
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                    // ListTile(
                    //   title: const Text('Konsultasi'),
                    //   selected: _selectedIndex == 1,
                    //   onTap: () {
                    //     // Update the state of the app
                    //     // _onItemTapped(1);
                    //     // Then close the drawer
                    //     // if (roleid == '3') {
                    //     //   Navigator.push(
                    //     //       context,
                    //     //       MaterialPageRoute(
                    //     //           builder: (context) => const KelasPage(keyword: 'nilaisiswa')));
                    //     // } else if (roleid == '2') {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => ListKonsultasi()));
                    //     // }
                    //   },
                    // ),
                    
                  ])
                : const Text(''),
            role == '2'
                ? Column(children: [
                    ListTile(
                      title: const Text('Home'),
                      selected: _selectedIndex == 0,
                      onTap: () {
                        // Update the state of the app
                        // _onItemTapped(0);
                        // Then close the drawer
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Homepage()));
                      },
                    ),
                    // ListTile(
                    //   title: const Text('Penimbangan'),
                    //   selected: _selectedIndex == 1,
                    //   onTap: () {
                    //     // Update the state of the app
                    //     // _onItemTapped(1);
                    //     // Then close the drawer
                    //     // if (roleid == '3') {
                    //     //   Navigator.push(
                    //     //       context,
                    //     //       MaterialPageRoute(
                    //     //           builder: (context) => const KelasPage(keyword: 'nilaisiswa')));
                    //     // } else if (roleid == '2') {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) =>
                    //                 const PenimbanganPageUsers()));
                    //     // }
                    //   },
                    // ),
                    // ListTile(
                    //   title: const Text('Imunisasi'),
                    //   selected: _selectedIndex == 2,
                    //   onTap: () {
                    //     // Update the state of the app
                    //     // _onItemTapped(2);
                    //     // Then close the drawer

                    //     // if (roleid == '3') {
                    //     //   Navigator.push(
                    //     //       context,
                    //     //       MaterialPageRoute(
                    //     //           builder: (context) => const KelasPage(keyword: 'jadwalpelajaranSiswa')));
                    //     // } else if (roleid == '2') {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) =>
                    //                 const ImunisasiUsersById()));
                    //     // }
                    //   },
                    // ),
                    // ListTile(
                    //   title: const Text('Konsultasi'),
                    //   selected: _selectedIndex == 3,
                    //   onTap: () {
                    //     // Update the state of the app
                    //     // _onItemTapped(3);
                    //     // Then close the drawer
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => KonsultasiOrtu()));
                    //   },
                    // ),
                    // ListTile(
                    //   title: const Text('Keluhan'),
                    //   selected: _selectedIndex == 3,
                    //   onTap: () {
                    //     // Update the state of the app
                    //     // _onItemTapped(3);
                    //     // Then close the drawer
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const KeluhanPage()));
                    //   },
                    // ),
                  ])
                : const Text(''),
          ],
        ),
      ),
    );
  }
}
