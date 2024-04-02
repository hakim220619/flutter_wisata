import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata/login/service/servicePage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:wisata/wisata/listwisataadmin.dart';
import 'package:wisata/wisata/serviceWisata.dart';

class EditWisataAdminPage extends StatefulWidget {
  const EditWisataAdminPage(
      {Key? key,
      required this.id,
      required this.namaWisata,
      required this.keterangan,
      required this.description,
      required this.tag,
      required this.tag1,
      required this.image1,
      required this.image2,
      required this.image3,
      required this.image4,
      required this.wilayah})
      : super(key: key);
  final String id;
  final String namaWisata;
  final String keterangan;
  final String description;
  final String tag;
  final String tag1;
  final String image1;
  final String image2;
  final String image3;
  final String image4;
  final String wilayah;

  @override
  _EditWisataAdminPageState createState() => _EditWisataAdminPageState();
}

List _listsData = [];

class _EditWisataAdminPageState extends State<EditWisataAdminPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _namawisata = '';
  String _keterangan = '';
  String _description = '';
  String _tag = '';
  String _tag1 = '';
  // ignore: override_on_non_overriding_member
  String? imagePath1;
  String? imagePath2;
  String? imagePath3;
  String? imagePath4;
  var _wilayahAll;

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  TextEditingController tanggal_lahir = TextEditingController();

  Widget build(BuildContext context) {
    final List<String> wisatalist = <String>[
      "Bengkalis",
      "Dumai",
      "Siak Sri Indrapura",
    ];
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Edit Wisata'),
              leading: IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: _formKey,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: widget.namaWisata.toString(),
                          // controller: TextEditingController(text: namaWisata.toString()),
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan Nama Wisata';
                            }
                            return null;
                          },
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon:
                                  const Icon(Icons.format_align_justify),
                              labelText: 'Nama Wisata',
                              hintText: 'Nama Wisata'),
                          onChanged: (value) {
                            setState(() {
                              _namawisata = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: widget.keterangan.toString(),
                          // controller: TextEditingController(text: namaWisata.toString()),
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan Keterangan';
                            }
                            return null;
                          },
                          maxLines: 3,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon:
                                  const Icon(Icons.format_align_justify),
                              labelText: 'Keterangan',
                              hintText: 'Keterangan'),
                          onChanged: (value) {
                            setState(() {
                              _keterangan = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: widget.description.toString(),
                          // controller: TextEditingController(text: namaWisata.toString()),
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan Description';
                            }
                            return null;
                          },
                          maxLines: 10,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon:
                                  const Icon(Icons.format_align_justify),
                              labelText: 'Description',
                              hintText: 'Description'),
                          onChanged: (value) {
                            setState(() {
                              _description = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: widget.tag.toString(),
                          // controller: TextEditingController(text: namaWisata.toString()),
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan Tag';
                            }
                            return null;
                          },
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon:
                                  const Icon(Icons.format_align_justify),
                              labelText: 'Tag',
                              hintText: 'Tag'),
                          onChanged: (value) {
                            setState(() {
                              _tag = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: widget.tag1.toString(),
                          // controller: TextEditingController(text: namaWisata.toString()),
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan Tag';
                            }
                            return null;
                          },
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon:
                                  const Icon(Icons.format_align_justify),
                              labelText: 'Tag',
                              hintText: 'Tag'),
                          onChanged: (value) {
                            setState(() {
                              _tag1 = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        containerImageWidget1(context),
                        containerImageWidget2(context),
                        containerImageWidget3(context),
                        containerImageWidget4(context),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.format_align_justify),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText: 'Wilayah'),
                          isExpanded: true,
                          items: wisatalist.map(
                            (item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            },
                          ).toList(),
                          validator: (value) {
                            if (value == null) return 'Silahkan Masukan Data';
                            return null;
                          },
                          value: widget.wilayah,
                          onChanged: (vale) {
                            setState(() {
                              _wilayahAll = vale;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                            onTap: () async {
                              print(imagePath1);
                              if (_formKey.currentState!.validate()) {
                                await HttpServiceWisata().updateWisata(
                                    widget.id,
                                    _namawisata == ''
                                        ? widget.namaWisata
                                        : _namawisata,
                                    _keterangan == ''
                                        ? widget.keterangan
                                        : _keterangan,
                                    _description == ''
                                        ? widget.description
                                        : _description,
                                    _tag == '' ? widget.tag : _tag,
                                    _tag1 == '' ? widget.tag1 : _tag1,
                                    imagePath1,
                                    imagePath2,
                                    imagePath3,
                                    imagePath4,
                                    _wilayahAll == null
                                        ? widget.wilayah
                                        : _wilayahAll,
                                    context);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 10),
                              child: const Center(
                                child: Text(
                                  "Update",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(9, 107, 199, 1),
                                  borderRadius: BorderRadius.circular(10)),
                            )),
                        InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await HttpServiceWisata()
                                    .delete(widget.id, context);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 10),
                              child: const Center(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  Widget containerImageWidget1(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          final path = await chooseImage1();
          setState(() {
            imagePath1 = path;
            // print(imagePath);
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(.40)),
            borderRadius: BorderRadius.circular(4),
            image: imagePath1 != null
                ? DecorationImage(
                    image: FileImage(File(imagePath1!)), fit: BoxFit.cover)
                : DecorationImage(
                    image: NetworkImage(
                        '${dotenv.env['url_image']}storage/images/wisata/${widget.image1}'),
                    fit: BoxFit.fill,
                  ),
          ),
          child: Visibility(
              visible: imagePath1 == null ? true : false,
              child: const Text('Pilih gambar')),
        ));
  }
  Widget containerImageWidget2(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          final path = await chooseImage2();
          setState(() {
            imagePath2 = path;
            // print(imagePath);
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(.40)),
            borderRadius: BorderRadius.circular(4),
            image: imagePath2 != null
                ? DecorationImage(
                    image: FileImage(File(imagePath2!)), fit: BoxFit.cover)
                : DecorationImage(
                    image: NetworkImage(
                        '${dotenv.env['url_image']}storage/images/wisata/${widget.image2}'),
                    fit: BoxFit.fill,
                  ),
          ),
          child: Visibility(
              visible: imagePath2 == null ? true : false,
              child: const Text('Pilih gambar')),
        ));
  }
  Widget containerImageWidget3(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          final path = await chooseImage3();
          setState(() {
            imagePath3 = path;
            // print(imagePath3);
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(.40)),
            borderRadius: BorderRadius.circular(4),
            image: imagePath3 != null
                ? DecorationImage(
                    image: FileImage(File(imagePath3!)), fit: BoxFit.cover)
                : DecorationImage(
                    image: NetworkImage(
                        '${dotenv.env['url_image']}storage/images/wisata/${widget.image3}'),
                    fit: BoxFit.fill,
                  ),
          ),
          child: Visibility(
              visible: imagePath3 == null ? true : false,
              child: const Text('Pilih gambar')),
        ));
  }
  Widget containerImageWidget4(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          final path = await chooseImage4();
          setState(() {
            imagePath4 = path;
            // print(imagePath4);
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(.40)),
            borderRadius: BorderRadius.circular(4),
            image: imagePath4 != null
                ? DecorationImage(
                    image: FileImage(File(imagePath4!)), fit: BoxFit.cover)
                : DecorationImage(
                    image: NetworkImage(
                        '${dotenv.env['url_image']}storage/images/wisata/${widget.image4}'),
                    fit: BoxFit.fill,
                  ),
          ),
          child: Visibility(
              visible: imagePath4 == null ? true : false,
              child: const Text('Pilih gambar')),
        ));
  }
}

Future<String?> chooseImage1() async {
  final ImagePicker picker = ImagePicker();
  final image1 = await picker.pickImage(source: ImageSource.gallery);
  return image1!.path;
}
Future<String?> chooseImage2() async {
  final ImagePicker picker = ImagePicker();
  final image2 = await picker.pickImage(source: ImageSource.gallery);
  return image2!.path;
}
Future<String?> chooseImage3() async {
  final ImagePicker picker = ImagePicker();
  final image3 = await picker.pickImage(source: ImageSource.gallery);
  return image3!.path;
}
Future<String?> chooseImage4() async {
  final ImagePicker picker = ImagePicker();
  final image4 = await picker.pickImage(source: ImageSource.gallery);
  return image4!.path;
}
