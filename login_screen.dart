import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadpreferences();
  }

  //load save pref data (email & password)
  Future<void> _loadpreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailcontroller.text = prefs.getString('email') ?? '';
      _passwordcontroller.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  // save pref only if rememberMe is active
  Future<void> _savepreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _emailcontroller.text);
      await prefs.setString('password', _passwordcontroller.text);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }

    await prefs.setBool(
        ' rememberMe', _rememberMe); //save the situation of rememberMe
  }

  //login method
  void _login() async {
    if (_emailcontroller.text.isEmpty || _passwordcontroller.text.isEmpty) {
      _showMessage("please enter  your email and password!");
      return null;
    }

    //savepref
    await _savepreferences();

    // successful login
    _showMessage("login successfull!");
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Email feild
            TextField(
              controller: _emailcontroller,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                hintText: "demo@demo.com",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            //Password Feild
            TextField(
              controller: _passwordcontroller,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.password),
                border: OutlineInputBorder(),
              ),
              obscureText: false,
            ),
            SizedBox(height: 20),
            //RememberMe checkBox
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                Text("RememberMe"),
              ],
            ),
            SizedBox(height: 20),

            //Login button
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
