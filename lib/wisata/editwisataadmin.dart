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
      required this.image
      })
      : super(key: key);
  final String id;
  final String namaWisata;
  final String keterangan;
  final String description;
  final String tag;
  final String tag1;
  final String image;

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
   String? imagePath;

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  TextEditingController tanggal_lahir = TextEditingController();

  Widget build(BuildContext context) {
    // final List<String> nameList = <String>[
    //   "Laki-Laki",
    //   "Perempuan",
    // ];
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
                        containerImageWidget(context),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await HttpServiceWisata().updateWisata(  
                                  widget.id,
                                 _namawisata == '' ? widget.namaWisata : _namawisata,
                                _keterangan == '' ? widget.keterangan : _keterangan,
                                _description == '' ? widget.description : _description,
                                _tag == '' ? widget.tag : _tag,
                                _tag1 == '' ? widget.tag1 : _tag1,
                               imagePath,
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
                                await HttpServiceWisata().delete(  
                                  widget.id,
                               context);
                                
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

 Widget containerImageWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final path = await chooseImage();
        setState(() {
          imagePath = path;
          // print(imagePath);
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(.40)
          ),
          borderRadius: BorderRadius.circular(4),
          image: imagePath != null ?
            DecorationImage(
              image: FileImage(File(imagePath!)),
              fit: BoxFit.cover
            ) : DecorationImage(
      image: NetworkImage('${dotenv.env['url_image']}storage/images/wisata/${widget.image}'),
      fit: BoxFit.fill,
    ),
        ),
        child: Visibility(
          visible: imagePath == null ? true : false,
          child: const Text('Pilih gambar')
        ),)
    );
  }
}

Future<String?> chooseImage() async {
  final ImagePicker picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.gallery);
  return image!.path;
}
