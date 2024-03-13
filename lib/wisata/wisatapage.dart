import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_card/image_card.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

import 'package:wisata/components/like/data.dart' as data;
import 'package:wisata/components/like/image.dart';
import 'package:wisata/components/like/post.dart';

class ListWisataPage extends StatefulWidget {
  const ListWisataPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ListWisataPage> createState() => _ListWisataPageState();
}

List _listsData = [];

class _ListWisataPageState extends State<ListWisataPage> {
  Future<dynamic> lisWisata() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var url = Uri.parse('${dotenv.env['url']}/getWisata');
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      // print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print(data);
        setState(() {
          _listsData = data['data'];
          print(_listsData);
        });
      }
    } catch (e) {
      // print(e);
    }
  }

  // Sample data for three lists
  @override
  void initState() {
    super.initState();
    lisWisata();
  }

  Future refresh() async {
    setState(() {
      lisWisata();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          itemCount: _listsData.length,
          itemBuilder: (context, index) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              PostWidget(
                
                title: _title(title: _listsData[index]['nama_wisata']),
                description: _content(desc: _listsData[index]['keterangan']),

                imgPath: 'assets/images/wisata/pantai1.jpg',
                reactions: data.reactions,
              ),
              
              
              const SafeArea(
                child: SizedBox(),
              ),
            ],
          ),
        ),
          // ),
        ),
      ),
    );
  }
}



Widget _title({title, Color? color}) {
  return Text(
    '$title',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
  );
}

Widget _content({desc, Color? color}) {
  return Text(
    '$desc',
    style: TextStyle(color: color),
  );
}

Widget _footer({Color? color}) {
  return Row(
    children: [
      CircleAvatar(
        backgroundImage: AssetImage(
          'assets/wisata/pantai1.jpg',
        ),
        radius: 12,
      ),
      const SizedBox(
        width: 4,
      ),
      Expanded(
          child: Text(
        'Super user',
        style: TextStyle(color: color),
      )),
      IconButton(onPressed: () {}, icon: Icon(Icons.share))
    ],
  );
}

Widget _tag(String tag, VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.green),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        tag,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

