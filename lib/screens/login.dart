import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile/screens/home.dart';
import 'package:flutter_mobile/screens/signup.dart';
import 'package:flutter_mobile/shared_preference_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              _header(context),
              _inputField(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: [
          SizedBox(
            height: 200, // Adjust the height as needed
            width: 150, // Adjust the width as needed
            child: Image.asset(
              'assets/images/logo1.png', // Replace this with your image path
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
          ),
          const Text(
            "Lost Seeker",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const Text("Enter your credentials to login"),
          const SizedBox(
            height: 50.0,
          )
        ],
      ),
    );
  }

  Widget _inputField(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: TextField(
            controller: _email,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: const Color.fromARGB(255, 40, 5, 238).withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: TextField(
            controller: _password,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: const Color.fromARGB(255, 40, 5, 238).withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.lock),
            ),
            obscureText: true,
          ),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            login();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromARGB(255, 193, 235, 8),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(
          height: 50.0,
        )
      ],
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Color.fromARGB(255, 54, 8, 219)),
          ),
        )
      ],
    );
  }

  void login() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      sh.remove('USER_ID');
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
      final user = auth.currentUser;
      if (user != null) {
        SharedPreferenceHelper.saveUserID(user.uid);
      } else {
        showErrorSnackbar('Login Failed');
      }

      showSuccessToast("Login success");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } catch (e) {
      showErrorSnackbar(e.toString());
    }
  }

  void showErrorSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        showCloseIcon: false,
      ),
    );
  }

  void showSuccessToast(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
        textColor: Colors.white,
        backgroundColor: Colors.green);
  }
}
