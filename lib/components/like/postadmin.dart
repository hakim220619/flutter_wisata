import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata/components/like/data.dart' as data;
import 'package:http/http.dart' as http;
import 'package:comment_box/comment/comment.dart';
import 'package:comment_box/comment/test.dart';
import 'package:comment_box/main.dart';
import 'package:wisata/wisata/detailWisata.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wisata/wisata/editwisataadmin.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostWidgetAdmin extends StatefulWidget {
  const PostWidgetAdmin({
    Key? key,
    this.id,
    this.title,
    required this.rate,
    required this.imgPath1,
    required this.imgPath2,
    required this.imgPath3,
    required this.imgPath4,
    required this.reactions,
    this.description,
  }) : super(key: key);

  final String? id;
  final String imgPath1;
  final String imgPath2;
  final String imgPath3;
  final String imgPath4;
  final double rate;

  final Widget? title;
  final Widget? description;
  final List<Reaction<String>> reactions;

  @override
  State<PostWidgetAdmin> createState() => _PostWidgetAdminState();
}

List _listsData = [];

class _PostWidgetAdminState extends State<PostWidgetAdmin> {
  // Sample data for three lists
  @override
  void initState() {
    super.initState();
    // print(widget.id);
  }

  late SharedPreferences profileData;
  String? role;
  void initial() async {
    profileData = await SharedPreferences.getInstance();
    setState(() {
      role = profileData.getString('role');
    });
  }

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onDoubleTap: () async {
                  print('delete');
                  final _client = http.Client();
                  final _deleteComment =
                      Uri.parse('${dotenv.env['url']}/deleteComment');
                  // Display the image in large form.
                  try {
                    EasyLoading.show(status: 'loading...');
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    var token = preferences.getString('token');
                    http.Response response =
                        await _client.post(_deleteComment, body: {
                      'id': _listsData[i]['id']
                    }, headers: {
                      "Accept": "application/json",
                      "Authorization": "Bearer $token",
                    });
                    if (response.statusCode == 200) {
                      lisComment();
                      Navigator.pop(context);
                      commentController.clear();
                      FocusScope.of(context).unfocus();
                    }
                    EasyLoading.dismiss();

                    // ignore: use_build_context_synchronously
                  } catch (e) {
                    print(e);
                  }
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: 'assets/images/users.png')),
                ),
              ),
              title: Text(
                _listsData[i]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_listsData[i]['comment']),
              trailing: Text(_listsData[i]['created_at'],
                  style: TextStyle(fontSize: 10)),
            ),
          )
      ],
    );
  }

  Future<dynamic> lisComment() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var url = Uri.parse('${dotenv.env['url']}/listCommentById');
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
          
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (BuildContext context) {
              return  SizedBox(
                  height: 600,
                  child: commentChild(_listsData)
                      ) ;
            },
          );
        });
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    int _current = 0;

    final List<String> imgList = [
      widget.imgPath1,
      widget.imgPath2,
      widget.imgPath3,
      widget.imgPath4,
    ];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Column(
          children: [
            InkWell(
              child: AspectRatio(
                aspectRatio: 2,
                child: Container(
                    child: CarouselSlider(
                  options: CarouselOptions(),
                  items: imgList
                      .map((item) => Container(
                            child: Center(
                                child: Image.network(item,
                                    fit: BoxFit.cover, width: 1000)),
                          ))
                      .toList(),
                )),
              ),
            ),
            if (widget.title != null || widget.description != null)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.title != null) widget.title!,
                    RatingBar.builder(
                      itemSize: 20,
                      initialRating: widget.rate.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.all(10),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    if (widget.title != null && widget.description != null)
                      const SizedBox(
                        height: 2,
                      ),
                    if (widget.description != null) widget.description!,
                  ],
                ),
              ),
            Center(
              child: Container(
                height: 58,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  children: [
                    Icon(
                      Icons.message,
                      size: 17,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      child: Text(
                        'Comment',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        lisComment();
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

final formKey = GlobalKey<FormState>();
final TextEditingController commentController = TextEditingController();
