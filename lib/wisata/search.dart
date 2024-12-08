import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata/components/like/post.dart';
import 'package:wisata/login/view/login.dart';
import 'package:wisata/wisata/detailWisata.dart';
import 'package:wisata/wisata/providers.dart';
import 'package:wisata/wisata/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisata/components/like/data.dart' as react;
import 'package:http/http.dart' as http;

class SearchWisataRiverpod extends ConsumerWidget {
  const SearchWisataRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _client = http.Client();
    final _logoutUrl = Uri.parse('${dotenv.env['url']}/logout');

    // ignore: non_constant_identifier_names
    Future Logout() async {
      try {
        EasyLoading.show(status: 'loading...');
        SharedPreferences preferences = await SharedPreferences.getInstance();

        // Mengambil token dari SharedPreferences
        var token = preferences.getString('token');

        // Melakukan request logout
        http.Response response = await _client.get(_logoutUrl, headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        });

        print(response.body);

        // Menghapus data di SharedPreferences setelah logout
        await preferences.remove('email');
        await preferences.remove('id');
        await preferences.remove('name');
        await preferences.remove('role');
        await preferences.remove('token');
        await preferences.remove('is_login');

        EasyLoading.dismiss();

        // Mengarahkan pengguna ke halaman login
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage(),
          ),
          (route) => false,
        );
      } catch (e) {
        print(e);
      }
    }

    Future<void> _showMyDialog(String title, String text, String nobutton,
        String yesbutton, Function onTap, bool isValue) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: isValue,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(text),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(nobutton),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(yesbutton),
                onPressed: () async {
                  Logout();
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          );
        },
      );
    }

    final getAllUser = ref.watch(getUserProvider);
    final searchText = ref.watch(searchUserProvider);
    final searchController = ref.watch(searchControllerProvider);
    // final stateKey = ref.watch();
    return GestureDetector(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wisata',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: () {
              _showMyDialog('Log Out', 'Are you sure you want to logout?', 'No',
                  'Yes', () async {}, false);

              // ignore: unused_label
              child:
              Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async => ref.refresh(getUserProvider),
          child: getAllUser.when(
            data: (data) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        ref
                            .watch(searchUserProvider.notifier)
                            .update((state) => state = value);
                        ref
                            .watch(searchControllerProvider.notifier)
                            .onSearchUser(searchText, data['data']);
                      },
                      // onTapOutside: (value) {
                      //   ref
                      //       .watch(searchControllerProvider.notifier)
                      //       .onSearchUser(searchText, data['data']);
                      // },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: const Text('Bengkalis'),
                        onTap: () {
                          ref
                              .watch(searchUserProvider.notifier)
                              .update((state) => state = 'Bengkalis');
                          ref
                              .watch(searchControllerProvider.notifier)
                              .onTap('Bengkalis', data['data']);
                        },
                      ),
                      InkWell(
                        child: const Text('Dumai'),
                        onTap: () {
                          ref
                              .watch(searchUserProvider.notifier)
                              .update((state) => state = 'Dumai');
                          ref
                              .watch(searchControllerProvider.notifier)
                              .onTap('Dumai', data['data']);
                        },
                      ),
                      InkWell(
                        child: const Text('Siak Sri Indrapura'),
                        onTap: () {
                          ref
                              .watch(searchUserProvider.notifier)
                              .update((state) => state = 'Siak Sri Indrapura');
                          ref
                              .watch(searchControllerProvider.notifier)
                              .onTap('Siak Sri Indrapura', data['data']);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: const Text('Alam'),
                        onTap: () {
                          ref
                              .watch(searchUserProvider.notifier)
                              .update((state) => state = 'Alam');
                          ref
                              .watch(searchControllerProvider.notifier)
                              .onTapTag1('Alam', data['data']);
                        },
                      ),
                      InkWell(
                        child: const Text('Buatan'),
                        onTap: () {
                          ref
                              .watch(searchUserProvider.notifier)
                              .update((state) => state = 'buatan');
                          ref
                              .watch(searchControllerProvider.notifier)
                              .onTapTag1('buatan', data['data']);
                        },
                      ),
                      InkWell(
                        child: const Text('Sejarah'),
                        onTap: () {
                          ref
                              .watch(searchUserProvider.notifier)
                              .update((state) => state = 'sejarah');
                          ref
                              .watch(searchControllerProvider.notifier)
                              .onTapTag1('sejarah', data['data']);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: searchController.isNotEmpty
                        ? searchController.length
                        : data['data'].length,
                    itemBuilder: (context, index) {
                      // print(data['data']);
                      final user = searchController.isNotEmpty
                          ? searchController[index]
                          : data['data'][index];
                      // print(user['rate']);
                      return InkWell(
                        onTap: () async {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DetailWisataPage(id: user['id'].toString()),
                            ),
                          );
                        },
                        child: PostWidget(
                          id: user['id'].toString(),
                          rate: user['rate'] == null
                              ? 0.0
                              : dotenv.env['production'] == 'true'
                                  ? double.tryParse(user['rate'].toString()) ??
                                      0.0
                                  : double.tryParse(user['rate'].toString()) ??
                                      0.0,

                          title: _title(title: user['nama_wisata']),
                          description: _content(desc: user['keterangan']),
                          imgPath1:
                              '${dotenv.env['url_image']}/storage/images/wisata/${user['image1']}',
                          imgPath2:
                              '${dotenv.env['url_image']}/storage/images/wisata/${user['image2']}',
                          imgPath3:
                              '${dotenv.env['url_image']}/storage/images/wisata/${user['image3']}',
                          imgPath4:
                              '${dotenv.env['url_image']}/storage/images/wisata/${user['image4']}',
                          // imgPath: 'assets/images/wisata/pantai1.jpg',
                          reactions: react.reactions,
                        ),
                      );

                      // ),
                    },
                  )),
                ],
              ),
            ),
            error: (error, stackTrace) => const SizedBox(
              height: double.infinity,
              child: Center(
                child: Text('Something went wrong'),
              ),
            ),
            loading: () => const SizedBox(
              height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )),
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
