import 'package:flutter/material.dart';
import 'package:capstone_test/db.dart' as db;
import 'package:capstone_test/screenTest.dart';

// user can create account and add it to local database. Account can only be created if certain password conditions are met
class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final pConfirmController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  String helpText = "";
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_checkInput);
    passwordController.addListener(_checkInput);
    pConfirmController.addListener(_checkInput);
    emailController.addListener(_checkInput);
    ageController.addListener(_checkInput);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    pConfirmController.dispose();
    emailController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void _checkInput() async {
    bool uniqueUsername =
        await db.checkIfUsernameExists(usernameController.text);

    bool hasText = usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        pConfirmController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        ageController.text.isNotEmpty;

    bool strongPass = RegExp(
            r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$')
        .hasMatch(passwordController.text);

    bool pMatches = passwordController.text == pConfirmController.text;

    setState(() {
      isButtonEnabled = hasText && strongPass && pMatches && uniqueUsername;
      if (!hasText) {
        helpText = "Please enter your information";
      } else if (!strongPass) {
        helpText =
            "Please make a stronger password\nIt must include 1 uppercase letter, 1 lowercase letter, a number, \n and a special character";
      } else if (!pMatches) {
        helpText = "Passwords must match";
      } else if (!uniqueUsername) {
        helpText = "Please choose a different username";
      } else {
        helpText = "";
      }
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

                  // username box
                  const SizedBox(height: 40),
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
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      showCursor: false,
                      style: const TextStyle(
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0,
                      ),
                      controller: usernameController,
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

                  // password
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
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      showCursor: false,
                      obscureText: true,
                      style: const TextStyle(
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0),
                      controller: passwordController,
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

                  //confirm password
                  const SizedBox(height: 20),
                  const Text("Confirm Password",
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
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      showCursor: false,
                      obscureText: true,
                      style: const TextStyle(
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0),
                      controller: pConfirmController,
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

                  //email
                  const SizedBox(height: 20),
                  const Text("Email Address",
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
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      showCursor: false,
                      style: const TextStyle(
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0),
                      controller: emailController,
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

                  //age
                  const SizedBox(height: 20),
                  const Text("Age",
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
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      showCursor: false,
                      style: const TextStyle(
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0),
                      controller: ageController,
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
                  Center(
                    child: Text(
                      helpText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                      textAlign: TextAlign
                          .center, // Optional: This ensures text alignment is centered within the Text widget.
                    ),
                  ),

// need to implement a checkbox
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            createAccount();
                            final snackBar = SnackBar(
                              content: Text(
                                  'Welcome ${usernameController.text} \nYou have successfully created your account'),
                              action: SnackBarAction(
                                  label: 'Close', onPressed: () {}),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonEnabled
                          ? const Color(0xff8491d9)
                          : Colors.grey[400],
                    ),
                    child: const Text('Create Account'),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }

  void createAccount() {
    String username = usernameController.text;
    String password = passwordController.text;
    String email = emailController.text;
    int age = int.parse(ageController.text);

    db.insertUser(db.User(
        age: age,
        username: username,
        password: password,
        email: email,
        level: 1,
        accuracy: 1.0));

    Navigator.pop(context);
  }
}
