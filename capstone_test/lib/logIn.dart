import 'package:flutter/material.dart';
import 'package:capstone_test/db.dart' as db;
import 'package:capstone_test/screenTest.dart';
import 'package:capstone_test/homePage.dart';

// User can log in if they have an existing account
class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  LogInState createState() => LogInState();
}

class LogInState extends State<LogIn> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_checkInput);
    passwordController.addListener(_checkInput);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _checkInput() async {
    bool isValid =
        await db.checkPass(usernameController.text, passwordController.text);
    setState(() {
      this.isValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pop(); // Pop the current route when the back button is pressed
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Untitled-1.png'),
                opacity: .5,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 347, // Adjust according to your design
              height: 720, // Adjust according to your design
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(47)),

              child: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40),
                    const Image(
                      image: AssetImage('images/TODO_Logo copy.png'),
                      height: 150,
                    ),
                    const SizedBox(height: 20),

                    //Username
                    const Text("Username",
                        style: TextStyle(
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w700,
                            fontFamily: "OpenSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.left),
                    SizedBox(
                      height: 20,
                      width: 268,
                      child: TextFormField(
                        controller: usernameController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        style: const TextStyle(
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0),
                        //controller: ageController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0x408491d9),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0x408491d9), width: 2.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          isDense: true, // Added this
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text("Password",
                        style: TextStyle(
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w700,
                            fontFamily: "OpenSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.left),

                    SizedBox(
                      height: 20,
                      width: 268,
                      child: TextFormField(
                        controller: passwordController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        obscureText: true,
                        //controller: ageController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0x408491d9),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0x408491d9), width: 2.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          isDense: true, // Added this
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () {
                        isValid ? logInHelper() : null;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isValid
                            ? const Color(0xff8491d9)
                            : Colors.grey[400],
                      ),
                      child: const Text('Log In'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logInHelper() {
    final snackBar = SnackBar(
      content: Text(
          'Welcome ${usernameController.text} \nYou have successfully logged in'),
      action: SnackBarAction(label: 'Close', onPressed: () {}),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    gUsername = usernameController.text;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
