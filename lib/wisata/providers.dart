import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getUserProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var url = Uri.parse('${dotenv.env['url']}/getWisata');
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
 
  final jsonResponse = jsonDecode(response.body);
  print(jsonResponse);
  return jsonResponse;
});

final searchUserProvider = StateProvider<String>((ref) => '');

