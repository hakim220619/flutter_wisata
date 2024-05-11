// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wisata/login/view/login.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata/home/HomePage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wisata/wisata/listwisataadmin.dart';
import 'package:wisata/wisata/search.dart';
import 'package:wisata/wisata/wisatapage.dart';

class HttpServiceWisata {
  Future<void> updateWisata(id, nama_wisata, keterangan, description, tag, tag1,
      gambar1, gambar2, gambar3, gambar4,  wilayah, context) async {
    // print(gambar);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url = Uri.parse('${dotenv.env['url']}/update-wisata');
    var request = http.MultipartRequest("POST", url);
    final imagepath1 = await http.MultipartFile.fromPath('image1', gambar1);
    final imagepath2 = await http.MultipartFile.fromPath('image2', gambar2);
    final imagepath3 = await http.MultipartFile.fromPath('image3', gambar3);
    final imagepath4 = await http.MultipartFile.fromPath('image4', gambar4);
    // print(imagepath1);
    request.fields['id'] = id;
    request.fields['nama_wisata'] = nama_wisata;
    request.fields['keterangan'] = keterangan;
    request.fields['description'] = description;
    request.fields['tag'] = tag;
    request.fields['tag1'] = tag1;
    request.fields['wilayah'] = wilayah;
    request.files.add(imagepath1);
    request.files.add(imagepath2);
    request.files.add(imagepath3);
    request.files.add(imagepath4);

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';

    final response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    // print(responseString);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const ListWisataAdminPage(),
      ),
    );
  }

  Future<void> addWisata(
      nama_wisata, keterangan, description, tag, tag1, wilayah, gambar1, gambar2, gambar3, gambar4, context) async {
    // print(imagePath);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url = Uri.parse('${dotenv.env['url']}/add-wisata');
    var request = http.MultipartRequest("POST", url);
    final imagepath1 = await http.MultipartFile.fromPath('image1', gambar1);
    final imagepath2 = await http.MultipartFile.fromPath('image2', gambar2);
    final imagepath3 = await http.MultipartFile.fromPath('image3', gambar3);
    final imagepath4 = await http.MultipartFile.fromPath('image4', gambar4);
    // print(imagepath);
    request.fields['nama_wisata'] = nama_wisata;
    request.fields['keterangan'] = keterangan;
    request.fields['description'] = description;
    request.fields['tag'] = tag;
    request.fields['tag1'] = tag1;
    request.fields['wilayah'] = wilayah;
    request.files.add(imagepath1);
    request.files.add(imagepath2);
    request.files.add(imagepath3);
    request.files.add(imagepath4);

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';

    final response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const ListWisataAdminPage(),
      ),
    );
  }

  Future<void> delete(id, context) async {
    // print(imagePath);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url = Uri.parse('${dotenv.env['url']}/delete-wisata');
    var request = http.MultipartRequest("POST", url);
    // print(imagepath);
    request.fields['id'] = id;

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';

    final response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const ListWisataAdminPage(),
      ),
    );
  }
}
