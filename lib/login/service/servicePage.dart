// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wisata/login/view/login.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata/home/HomePage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpService {
  static final _client =http.Client() ;

  static final _loginUrl = Uri.parse('${dotenv.env['url']}/login');

  static login(email, password, context) async {
    EasyLoading.show(status: 'loading...');
    http.Response response = await _client
        .post(_loginUrl, body: {"email": email, "password": password});

    // print(response.body);
    if (response.statusCode == 200) {
      // ignore: non_constant_identifier_names

      EasyLoading.dismiss();
      var Users = jsonDecode(response.body);
      // print(Users);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("email", email);
      await pref.setString("id", Users['userData']['id'].toString());
      await pref.setString("name", Users['userData']['name'].toString());
      await pref.setString("role", Users['userData']['role'].toString());
      await pref.setString("token", Users['token']);
      await pref.setBool("is_login", true);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const Homepage(),
        ),
        (route) => false,
      );
    } else {
      print(response);
      EasyLoading.showError('Login Gagal');
      EasyLoading.dismiss();
    }
  }

  static final _registerUrl = Uri.parse('${dotenv.env['url']}/register');
  static register(nik, name, email, password, address, jenis_kelamin, tanggal_lahir, nama_ortu, context) async {
        EasyLoading.show(status: 'loading...');
    http.Response response = await _client.post(_registerUrl, body: {
      "nik": nik,
      "name": name,
      "email": email,
      "password": password,
      "address": address,
      "jenis_kelamin": jenis_kelamin,
      "tanggal_lahir": tanggal_lahir.text,
      "nama_ortu": nama_ortu,
    });
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());

      if (json == 'username already exist') {
        await EasyLoading.showError(json);
      } else {
        EasyLoading.dismiss();
        Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage(),
        ),
        (route) => false,
      );
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }
}
