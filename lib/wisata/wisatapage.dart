// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:image_card/image_card.dart';
// import 'package:flutter_reaction_button/flutter_reaction_button.dart';

// import 'package:wisata/components/like/data.dart' as data;
// import 'package:wisata/components/like/image.dart';
// import 'package:wisata/components/like/post.dart';
// import 'package:wisata/login/view/login.dart';

// class ListWisataPage extends StatefulWidget {
//   const ListWisataPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<ListWisataPage> createState() => _ListWisataPageState();
// }

// List _listsData = [];

// class _ListWisataPageState extends State<ListWisataPage> {
//   Future<dynamic> lisWisata() async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       var token = preferences.getString('token');
//       var url = Uri.parse('${dotenv.env['url']}/getWisata');
//       final response = await http.get(url, headers: {
//         "Accept": "application/json",
//         "Authorization": "Bearer $token",
//       });
//       // print(response.body);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         // print(data);
//         setState(() {
//           _listsData = data['data'];
//           print(_listsData);
//         });
//       }
//     } catch (e) {
//       // print(e);
//     }
//   }

//    static final _client = http.Client();
//   static final _logoutUrl = Uri.parse('${dotenv.env['url']}/logout');

//   // ignore: non_constant_identifier_names
//   Future Logout() async {
//     try {
//       EasyLoading.show(status: 'loading...');
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       var token = preferences.getString('token');
//       http.Response response = await _client.get(_logoutUrl, headers: {
//         "Accept": "application/json",
//         "Authorization": "Bearer $token",
//       });
//       print(response.body);
//       if (response.statusCode == 200) {
//         SharedPreferences preferences = await SharedPreferences.getInstance();
//         setState(() {
//           preferences.remove("id");
//           preferences.remove("name");
//           preferences.remove("email");
//           preferences.remove("role");
//           preferences.remove("token");
//           preferences.remove("is_login");
//         });
//         EasyLoading.dismiss();
//         // ignore: use_build_context_synchronously
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (BuildContext context) => const LoginPage(),
//           ),
//           (route) => false,
//         );
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _showMyDialog(String title, String text, String nobutton,
//       String yesbutton, Function onTap, bool isValue) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: isValue,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(text),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text(nobutton),
//               onPressed: () => Navigator.pop(context),
//             ),
//             TextButton(
//               child: Text(yesbutton),
//               onPressed: () async {
//                 Logout();
//                 Navigator.of(context, rootNavigator: true).pop('dialog');
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

  
  

//   // Sample data for three lists
//   @override
//   void initState() {
//     super.initState();
//     lisWisata();
//   }

//   Future refresh() async {
//     setState(() {
//       lisWisata();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       appBar: AppBar(
//         title: const Text(
//           'Wisata',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.power_settings_new),
//             onPressed: () {
//               _showMyDialog('Log Out', 'Are you sure you want to logout?', 'No',
//                   'Yes', () async {}, false);

//               // ignore: unused_label
//               child:
//               Text(
//                 'Log Out',
//                 style: TextStyle(color: Colors.white),
//               );
//             },
//           )
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: refresh,
//         child: ListView.builder(
//           itemCount: _listsData.length,
//           itemBuilder: (context, index) => SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(vertical: 1),
//           child: Column(
//             children: [
//               // PostWidget(
//               //   id: _listsData[index]['id'].toString(),
//               //   title: _title(title: _listsData[index]['nama_wisata']),
//               //   description: _content(desc: _listsData[index]['keterangan']),
//               //   imgPath: '${dotenv.env['url']}/storage/images/wisata/pantai1.jpg',
//               //   reactions: data.reactions,
              
//               // ),
              
              
//               const SafeArea(
//                 child: SizedBox(),
//               ),
//             ],
//           ),
//         ),
//           // ),
//         ),
//       ),
//     );
//   }
// }



// Widget _title({title, Color? color}) {
//   return Text(
//     '$title',
//     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
//   );
// }

// Widget _content({desc, Color? color}) {
//   return Text(
//     '$desc',
//     style: TextStyle(color: color),
//   );
// }

// Widget _footer({Color? color}) {
//   return Row(
//     children: [
//       CircleAvatar(
//         backgroundImage: AssetImage(
//           'assets/wisata/pantai1.jpg',
//         ),
//         radius: 12,
//       ),
//       const SizedBox(
//         width: 4,
//       ),
//       Expanded(
//           child: Text(
//         'Super user',
//         style: TextStyle(color: color),
//       )),
//       IconButton(onPressed: () {}, icon: Icon(Icons.share))
//     ],
//   );
// }

// Widget _tag(String tag, VoidCallback onPressed) {
//   return InkWell(
//     onTap: onPressed,
//     child: Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(6), color: Colors.green),
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       child: Text(
//         tag,
//         style: TextStyle(color: Colors.white),
//       ),
//     ),
//   );
// }



