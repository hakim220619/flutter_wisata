import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:wisata/wisata/listWisataInPage.dart';
import 'package:wisata/wisata/listwisataadmin.dart';
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
      print(response.body);
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

  List locations = [];

  // Model to represent each card
  Future Sarpas() async {
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
        setState(() {
          locations = data['data'];
          // print(data['data']);
          // print('asd');
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // Sample data for three lists
  @override
  void initState() {
    super.initState();
    lisWisata();
    Sarpas();
  }

  Future refresh() async {
    setState(() {
      lisWisata();
      Sarpas();
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
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const SearchWisataRiverpod(),
              ),
              (route) => false,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: IntrinsicHeight(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(
                child: Column(children: [
                  Container(
                    height: 400.0,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RefreshIndicator(
                              onRefresh: refresh,
                              child: ListView.builder(
                                // shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (context, index) => Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  elevation: 2,
                                  child: SingleChildScrollView(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          child: AspectRatio(
                                            aspectRatio: 2,
                                            child: Image.network(
                                              '${dotenv.env['url_image']}storage/images/wisata/${_listsData[index]['image1']}',
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Text(
                                                  '${_listsData[index]['nama_wisata'].toString()}',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Center(
                                                  child: RatingBar.builder(
                                                itemSize: 40.0,
                                                initialRating: dotenv.env[
                                                            'production'] ==
                                                        'true'
                                                    ? double.parse(
                                                        _listsData[index]
                                                                ['rate']
                                                            .toString())
                                                    : (_listsData[index]
                                                                ['rate'] ==
                                                            null
                                                        ? 0.0
                                                        : double.parse(
                                                            _listsData[index]
                                                                    ['rate']
                                                                .toString())),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding: EdgeInsets.all(10),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) async {
                                                  final _client = http.Client();
                                                  final _urlRate = Uri.parse(
                                                      '${dotenv.env['url']}/rate');
                                                  SharedPreferences
                                                      preferences =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  var token = preferences
                                                      .getString('token');
                                                  var id_user = preferences
                                                      .getString('id');
                                                  EasyLoading.show(
                                                      status: 'loading...');
                                                  http.Response response =
                                                      await _client.post(
                                                    _urlRate,
                                                    headers: {
                                                      "Accept":
                                                          "application/json",
                                                      "Authorization":
                                                          "Bearer $token",
                                                    },
                                                    body: {
                                                      "id_user":
                                                          id_user.toString(),
                                                      "id_wisata":
                                                          widget.id.toString(),
                                                      "rate": rating.toString(),
                                                    },
                                                  );
                                                  if (response.statusCode ==
                                                      200) {
                                                    EasyLoading.dismiss();
                                                  } else {
                                                    await EasyLoading.showError(
                                                        "Error Code : ${response.statusCode.toString()}");
                                                  }
                                                },
                                              )),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                '${_listsData[index]['description'].toString()}',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black87),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // const ListWisataAdminPage()
                                        // const ListWisataInPage()
                                      ],
                                    ),
                                  ),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 140),
                      ],
                    ),
                  ),
                  Container(
                    height: 250.0,
                    child: ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(
                            '${dotenv.env['url_image']}/storage/images/wisata/${locations[index]['image1']}',
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          ),
                          title: Text('${locations[index]['nama_wisata']}'),
                          subtitle: Text('${locations[index]['keterangan']}'),
                          trailing: Icon(Icons.more_rounded),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DetailWisataPage(
                                        id: locations[index]['id']),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ));
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
