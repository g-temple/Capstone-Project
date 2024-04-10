import 'dart:ffi';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:capstone_test/db.dart' as db;

// global variable to reference for creating and updating tasks
String gUsername = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await db.DatabaseProvider
      .initializeDatabase(); // i think this initializes the database
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: WelcomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          const Image(
            image: AssetImage('images/logo.png'),
            height: 130,
          ),
          SizedBox(height: 40),
          ElevatedButton(
            child: const Text('Create Account'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateAccount()),
              );
            },
          ),
          ElevatedButton(
            child: const Text('Log In'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LogIn()),
              );
            },
          )
        ],
      )),
    );
  }
}

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
      //print(isButtonEnabled);
      if (!hasText) {
        helpText = "Please enter your information";
      } else if (!strongPass) {
        helpText = "Please make a stronger password";
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
        title: const Text('Create Account'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // username box
            SizedBox(height: 20),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Please create a username',
              ),
            ),
            // password
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                icon: Icon(Icons.key),
                hintText: 'Please create a password',
                // TODO need to do lots of logic to ensure strong passwords
              ),
            ),
            //confirm password
            SizedBox(height: 20),
            TextFormField(
              controller: pConfirmController,
              decoration: const InputDecoration(
                icon: Icon(Icons.remove_red_eye),
                hintText: 'Please confirm your password',
                // TODO need to do lots of logic to ensure strong passwords
              ),
            ),
            //email
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Please enter your email',
              ),
            ),
            //age
            SizedBox(height: 20),
            TextFormField(
              controller: ageController,
              decoration: const InputDecoration(
                icon: Icon(Icons.numbers),
                hintText: 'Please enter your age',
              ),
            ),
// Additional text widget to display static text
            SizedBox(height: 20),
            Text(
              helpText,
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 255, 0, 0)),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: isButtonEnabled ? createAccount : null,
              child: Text('Create Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonEnabled
                    ? Color.fromARGB(255, 192, 129, 226)
                    : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createAccount() async {
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
          title: const Text('LogIn'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.person), hintText: 'Enter Username'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.key), hintText: 'Enter Password'),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              child: const Text('Log In'),
              onPressed: () {
                // need a function to get a userId
                //gUserId =
                isValid
                    ? () => {
                          gUsername = usernameController.text,
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          )
                        }
                    : null;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid
                    ? Color.fromARGB(255, 192, 129, 226)
                    : Colors.grey[400],
              ),
            ),
          ],
        )));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          const Image(
            image: AssetImage('images/character.png'),
            height: 130,
          ),
          SizedBox(height: 40),
          ElevatedButton(
            child: const Text('TASKS'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskHome()),
              );
            },
          ),
          ElevatedButton(
            child: const Text('Rewards'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RewardsHome()),
              );
            },
          )
        ],
      )),
    );
  }
}

class TaskHome extends StatelessWidget {
  const TaskHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To Do!'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Task',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Do By',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Type',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Brush Teeth')),
                  DataCell(Text('10pm')),
                  DataCell(Text('Home')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Math Homework')),
                  DataCell(Text('8pm')),
                  DataCell(Text('School')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Pack Lunch')),
                  DataCell(Text('8am')),
                  DataCell(Text('Home')),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Add Tasks'),
            onPressed: () {},
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: const Text('View Completed Tasks'),
            onPressed: () {},
          ),
        ])));
  }
}

class RewardsHome extends StatelessWidget {
  const RewardsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          const Image(
            image: AssetImage('images/game.png'),
            height: 130,
          ),
          SizedBox(height: 40),
          ElevatedButton(
            child: const Text('Play Game'),
            onPressed: () {},
          ),
          SizedBox(height: 60),
          const Image(
            image: AssetImage('images/character.png'),
            height: 130,
          ),
          ElevatedButton(
            child: const Text('Customize Character'),
            onPressed: () {},
          )
        ],
      )),
    );
  }
}
