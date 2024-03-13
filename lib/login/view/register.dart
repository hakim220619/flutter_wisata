import 'package:flutter/material.dart';
import 'package:wisata/login/service/servicePage.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String nik;
  late String nama;
  late String email;
  late String password;
  late String address;
  var jenis_kelamin;

  late String bb_lahir;
  late String tb_lahir;
  late String nama_ortu;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  // ignore: override_on_non_overriding_member
  bool _passwordVisible = false;
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  TextEditingController tanggal_lahir = TextEditingController();

  Widget build(BuildContext context) {
    final List<String> nameList = <String>[
      "Laki-Laki",
      "Perempuan",
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
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
                    TextFormField(
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukan Nik';
                        }
                        return null;
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.person_3_outlined),
                          labelText: 'Masukan Nik',
                          hintText: 'Masukan Nik'),
                      onChanged: (value) {
                        setState(() {
                          nik = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukan Nama Lengkap';
                        }
                        return null;
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'Masukan Nama',
                          hintText: 'Masukan Nama'),
                      onChanged: (value) {
                        setState(() {
                          nama = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukan Email';
                        }
                        return null;
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.email),
                          labelText: 'Masukan Email',
                          hintText: 'Masukan Email'),
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: !_passwordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukan Password';
                        }
                        return null;
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordVisible =
                                    _passwordVisible ? false : true;
                              });
                            },
                            child: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          prefixIcon: const Icon(Icons.key),
                          labelText: 'Masukan Password',
                          hintText: 'Masukan Password'),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukan Address';
                        }
                        return null;
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.home),
                          labelText: 'Masukan Adrress',
                          hintText: 'Masukan Adrress'),
                      onChanged: (value) {
                        setState(() {
                          address = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.man_2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Jenis Kelamin'),
                      isExpanded: true,
                      items: nameList.map(
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
                      value: jenis_kelamin,
                      onChanged: (vale) {
                        setState(() {
                          jenis_kelamin = vale;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: tanggal_lahir,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.date_range),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Pilih Tanggal'),
                      validator: (value) {
                        if (value == false) return 'Silahkan Pilih Tanggal';
                        return null;
                      },
                      onTap: () async {
                        DateFormat('dd/mm/yyyy').format(DateTime.now());
                        var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1999),
                            lastDate: DateTime.now());
                        if (date == null) {
                          tanggal_lahir.text = "";
                        } else {
                          tanggal_lahir.text = date.toString().substring(0, 10);
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    
                    TextFormField(
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukan Nama Ortu';
                        }
                        return null;
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.person_2_sharp),
                          labelText: 'Masukan Nama Orang Tua',
                          hintText: 'Masukan Nama Orang Tua'),
                      onChanged: (value) {
                        setState(() {
                          nama_ortu = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await HttpService.register(
                                nik,
                                nama,
                                email,
                                password,
                                address,
                                jenis_kelamin,
                                tanggal_lahir,
                                nama_ortu,
                                context);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 1, vertical: 10),
                          child: const Center(
                            child: Text(
                              "Register",
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
        ),
      ),
    );
  }
}
