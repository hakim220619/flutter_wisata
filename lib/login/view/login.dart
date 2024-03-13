import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:wisata/login/service/servicePage.dart';
import 'package:wisata/login/view/register.dart';
// ignore: unused_import
import 'package:wisata/login/widget/login_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

bool _passwordVisible = false;

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailEditController = TextEditingController();
  late String email;
  late String password;

  // static const IconData directions_car =
  //     IconData(0xe1d7, fontFamily: 'MaterialIcons');
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 110.0),
                  child: Center(
                    child: SizedBox(
                        width: 200,
                        height: 100,
                        /*decoration: BoxDecoration( 
                          color: Colors.red, 
                          borderRadius: BorderRadius.circular(50.0)),*/
                        child: Image.asset('assets/images/logo/logo.png')),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextFormField(
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: emailEditController,
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
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    maxLines: 1,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _passwordVisible = _passwordVisible ? false : true;
                            });
                          },
                          child: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'Masukan Password',
                        hintText: 'Masukan Password'),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 65,
                  width: 360,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.fromLTRB(
                            150, 15, 150, 15), // foreground
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          HttpService.login(email, password, context);
                        }
                      },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 62),
                        child: Text('Do You have an Account? '),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterPage()));
                            },
                            child: const Text(
                              'Register Now.',
                              style: TextStyle(fontSize: 14, color: Colors.blue),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
