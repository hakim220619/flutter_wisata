import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wisata/wisata/search.dart';

class DetailWisataPage extends StatefulWidget {
  const DetailWisataPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<DetailWisataPage> createState() => _DetailWisataPageState();
}

List _listsData = [];

class _DetailWisataPageState extends State<DetailWisataPage> {
  Future<dynamic> lisWisata() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var url = Uri.parse('${dotenv.env['url']}/getDetailWisata');
      final response = await http.post(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      }, body: {
        'id_wisata': widget.id.toString()
      });
      // print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print(data);
        setState(() {
          _listsData = data['data'];
          // print(_listsData[0]['rate']);
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
        actions: const <Widget>[],
        title: const Text(
          "Detail Wisata",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SearchWisataRiverpod(),
        ),
       
      ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  InkWell(
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: Image.network(
                        '${dotenv.env['url_image']}storage/images/wisata/${_listsData[index]['image']}',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            '${_listsData[index]['nama_wisata'].toString()}',
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                        ),
                        Center(
                          child: RatingBar.builder(
                            itemSize: 40.0,
                            initialRating: dotenv.env['production'] == 'false' ?  _listsData[index]['rate'].toDouble() : _listsData[index]['rate'] == null ? 0.0 : double.parse(_listsData[index]['rate']),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.all(10),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) async {
                              final _client = http.Client();
                              final _urlRate =
                                  Uri.parse('${dotenv.env['url']}/rate');
                              // print(rating.toString());
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              var token = preferences.getString('token');
                              var id_user = preferences.getString('id');
                              EasyLoading.show(status: 'loading...');
                              http.Response response =
                                  await _client.post(_urlRate, headers: {
                                "Accept": "application/json",
                                "Authorization": "Bearer $token",
                              }, body: {
                                "id_user": id_user.toString(),
                                "id_wisata": widget.id.toString(),
                                "rate": rating.toString(),
                              });
                              // print(response.body);
                              // print(response.statusCode);
                              if (response.statusCode == 200) {
                                EasyLoading.dismiss();
                              } else {
                                await EasyLoading.showError(
                                    "Error Code : ${response.statusCode.toString()}");
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          '${_listsData[index]['description'].toString()}',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ),
          ),
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
