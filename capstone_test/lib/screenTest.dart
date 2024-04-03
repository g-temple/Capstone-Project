import 'dart:ffi';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:capstone_test/db.dart' as db;

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

  void _checkInput() {
    setState(() {
      isButtonEnabled = usernameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          pConfirmController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          ageController.text.isNotEmpty &&
          passwordController.text == pConfirmController.text &&
          // literal witchcraft but it works
          // function determines if a password is strong or not using regex
          RegExp(r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$')
              .hasMatch(passwordController.text);
      //print(isButtonEnabled);
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

// need to implement a checkbox
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

  void createAccount() {
    String username = usernameController.text;
    String password = passwordController.text;
    String email = emailController.text;
    int age = int.parse(ageController.text);

    db.insertUser(db.User(
        userid: 1,
        age: age,
        username: username,
        password: password,
        email: email,
        level: 1,
        accuracy: 1.0));

    // userid, age, username, password, email, level, accuracy
    //db.insertUser(User(,,username,password,email,0,1.0));
    // need to implement SQLite here so users can actually create an account and "log in"
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
                isValid
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      )
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
