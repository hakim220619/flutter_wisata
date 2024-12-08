import 'dart:convert';
import 'dart:io';

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
import 'package:image_picker/image_picker.dart'; // Image picker import

class PostWidget extends StatefulWidget {
  const PostWidget({
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
  State<PostWidget> createState() => _PostWidgetState();
}

List _listsData = [];

class _PostWidgetState extends State<PostWidget> {
  final ImagePicker _picker = ImagePicker();
  File? _image; // This will store the picked image
    // Create a TextEditingController to handle text input
    TextEditingController _commentController = TextEditingController();
  // Comment and image upload
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Use ImageSource.camera for camera
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the picked image
      });
    }
  }
  Future<void> _uploadComment() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var userId = preferences.getString('id');
      var url = Uri.parse('${dotenv.env['url']}/addCommentById');

      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      // Add the text comment
      request.fields['comment'] = _commentController.text;
      request.fields['id_wisata'] = widget.id.toString();
      request.fields['id_user'] = userId.toString();

      // If an image is selected, add it to the request
      if (_image != null) {
        var imageFile = await http.MultipartFile.fromPath(
          'image', // The name of the file field in the backend
          _image!.path, // Ensure _image is the correct variable holding the picked image
        );
        request.files.add(imageFile);
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        // Successfully uploaded the comment
        lisComment(); // Refresh the list of comments
        _commentController.clear(); // Clear the input field
        setState(() {
          _image = null; // Clear the selected image after upload
        });
        FocusScope.of(context).unfocus(); // Hide the keyboard
      } else {
        print('Failed to upload comment');
      }
    } catch (e) {
      print('Error uploading comment: $e');
    }
  }

  Future<dynamic> DatalisComment() async {
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
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listsData = data['data'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  late SharedPreferences profileData;
  String? role;
  void initial() async {
    profileData = await SharedPreferences.getInstance();
    setState(() {
      role = profileData.getString('role');
    });
  }

  Future<void> lisComment() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url = Uri.parse('${dotenv.env['url']}/listCommentById');
    final response = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    }, body: {
      'id_wisata': widget.id.toString()
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _listsData = data['data'];
      });
    }


    final ImagePicker _picker = ImagePicker(); // Initialize image picker
    String? _imagePath; // Store the path of the selected image

    // Show the bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 900, // Adjusted height to fit new content
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Comment Section',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _listsData.length,
                  itemBuilder: (context, index) {
                    var comment = _listsData[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () async {
                            print("Comment Clicked");
                          },
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: CommentBox.commentImageParser(
                                imageURLorPath: 'assets/images/users.png',
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          comment['name'] ?? 'Unknown User',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${comment['comment'] ?? 'No comment'}',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            // Display the image if available
                            if (comment['image_path'] != null)
                              Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Image.network(
                                      '${dotenv.env['url_image']}storage/${comment['image_path']}',
                                      fit: BoxFit.cover,
                                      width: 80)),

                            Text(
                              '${comment['created_at'] ?? 'No date'}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Text input field for new comment
              Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Enter your comment...',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      String newComment = _commentController.text.trim();
                      if (newComment.isNotEmpty || _image != null) {
                        // Upload comment
                        await _uploadComment();
                      }
                    },
                  ),
                ),
              ),
            ),
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
                onRatingUpdate: (rating) async {
                  final _client = http.Client();
                  final _urlRate = Uri.parse('${dotenv.env['url']}/rate');
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  var token = preferences.getString('token');
                  var id_user = preferences.getString('id');
                  EasyLoading.show(status: 'loading...');
                  http.Response response = await _client.post(
                    _urlRate,
                    headers: {
                      "Accept": "application/json",
                      "Authorization": "Bearer $token",
                    },
                    body: {
                      "id_user": id_user.toString(),
                      "id_wisata": widget.id.toString(),
                      "rate": rating.toString(),
                    },
                  );
                  print(rating);
                  print(response.body);
                  if (response.statusCode == 200) {
                    EasyLoading.dismiss();
                  } else {
                    await EasyLoading.showError(
                        "Error Code : ${response.statusCode.toString()}");
                  }
                },
              ),
              // Button to upload image
              ElevatedButton(
                onPressed: () async {
                  // Let the user pick an image from the gallery or take a photo
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource
                        .gallery, // Or use ImageSource.camera for camera input
                  );

                  if (image != null) {
                    print('Image selected: ${image.path}');
                    setState(() {
                      _imagePath = image.path; // Store the image path
                    });
                  } else {
                    print('No image selected');
                  }
                },
                child: Text('Upload Image'),
              ),
            ],
          ),
        );
      },
    );
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
                      onRatingUpdate: (rating) async {
                        final _client = http.Client();
                        final _urlRate = Uri.parse('${dotenv.env['url']}/rate');
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        var token = preferences.getString('token');
                        var id_user = preferences.getString('id');
                        EasyLoading.show(status: 'loading...');
                        http.Response response = await _client.post(
                          _urlRate,
                          headers: {
                            "Accept": "application/json",
                            "Authorization": "Bearer $token",
                          },
                          body: {
                            "id_user": id_user.toString(),
                            "id_wisata": widget.id.toString(),
                            "rate": rating.toString(),
                          },
                        );
                        print(response.body);
                        if (response.statusCode == 200) {
                          EasyLoading.dismiss();
                        } else {
                          await EasyLoading.showError(
                              "Error Code : ${response.statusCode.toString()}");
                        }
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
                      size: 19,
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
                    ),
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

Widget commentChild(data) {
  return ListView(
    children: [
      for (var i = 0; i < data.length; i++)
        Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
          child: ListTile(
            leading: GestureDetector(
              onTap: () async {
                print("Comment Clicked");
              },
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
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
            subtitle: Text(
                '${_listsData[i]['comment']} \n${_listsData[i]['created_at']}'),
          ),
        ),
    ],
  );
}

final formKey = GlobalKey<FormState>();
final TextEditingController commentController = TextEditingController();
