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

class AddWisataAdminPage extends StatefulWidget {
  const AddWisataAdminPage({Key? key}) : super(key: key);

  @override
  _AddWisataAdminPageState createState() => _AddWisataAdminPageState();
}

List _listsData = [];

class _AddWisataAdminPageState extends State<AddWisataAdminPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _namawisata = '';
  String _keterangan = '';
  String _description = '';
  String _tag = '';
  String _tag1 = '';
  String? wilayah;
  // ignore: override_on_non_overriding_member
  String? imagePath1;
  String? imagePath2;
  String? imagePath3;
  String? imagePath4;

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  TextEditingController tanggal_lahir = TextEditingController();

  Widget build(BuildContext context) {
    final List<String> wisata = <String>[
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
                          items: wisata.map(
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
                          value: wilayah,
                          onChanged: (vale) {
                            setState(() {
                              wilayah = vale;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await HttpServiceWisata().addWisata(
                                    _namawisata,
                                    _keterangan,
                                    _description,
                                    _tag,
                                    _tag1,
                                    wilayah,
                                    imagePath1,
                                    imagePath2,
                                    imagePath3,
                                    imagePath4,
                                    context);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 10),
                              child: const Center(
                                child: Text(
                                  "Simpan",
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
        final path = await chooseImage();
        setState(() {
          imagePath1 = path;
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
                : null),
        child: Visibility(
            visible: imagePath1 == null ? true : false,
            child: const Text('Pilih gambar')),
      ),
    );
  }
  Widget containerImageWidget2(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final path = await chooseImage();
        setState(() {
          imagePath2 = path;
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
                : null),
        child: Visibility(
            visible: imagePath2 == null ? true : false,
            child: const Text('Pilih gambar')),
      ),
    );
  }
  Widget containerImageWidget3(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final path = await chooseImage();
        setState(() {
          imagePath3 = path;
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
                : null),
        child: Visibility(
            visible: imagePath3 == null ? true : false,
            child: const Text('Pilih gambar')),
      ),
    );
  }
  Widget containerImageWidget4(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final path = await chooseImage();
        setState(() {
          imagePath4 = path;
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
                : null),
        child: Visibility(
            visible: imagePath4 == null ? true : false,
            child: const Text('Pilih gambar')),
      ),
    );
  }
}
 

Future<String?> chooseImage() async {
  final ImagePicker picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.gallery);
  return image!.path;
}
