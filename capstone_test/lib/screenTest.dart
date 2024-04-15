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
          const SizedBox(height: 20),
          const Image(
            image: AssetImage('images/logo.png'),
            height: 130,
          ),
          const SizedBox(height: 40),
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
            const SizedBox(height: 20),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Please create a username',
              ),
            ),
            // password
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                icon: Icon(Icons.key),
                hintText: 'Please create a password',
              ),
            ),
            //confirm password
            const SizedBox(height: 20),
            TextFormField(
              controller: pConfirmController,
              decoration: const InputDecoration(
                icon: Icon(Icons.remove_red_eye),
                hintText: 'Please confirm your password',
              ),
            ),
            //email
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Please enter your email',
              ),
            ),
            //age
            const SizedBox(height: 20),
            TextFormField(
              controller: ageController,
              decoration: const InputDecoration(
                icon: Icon(Icons.numbers),
                hintText: 'Please enter your age',
              ),
            ),
// Additional text widget to display static text
            const SizedBox(height: 20),
            Text(
              helpText,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 255, 0, 0)),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      createAccount();
                      final snackBar = SnackBar(
                        content: Text(
                            'Welcome ${usernameController.text} \nYou have successfully created your account'),
                        action:
                            SnackBarAction(label: 'Close', onPressed: () {}),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonEnabled
                    ? const Color.fromARGB(255, 192, 129, 226)
                    : Colors.grey[400],
              ),
              child: const Text('Create Account'),
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
            const SizedBox(height: 20),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.person), hintText: 'Enter Username'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.key), hintText: 'Enter Password'),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                isValid ? logInHelper() : null;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid
                    ? const Color.fromARGB(255, 192, 129, 226)
                    : Colors.grey[400],
              ),
              child: const Text('Log In'),
            ),
          ],
        )));
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
          const SizedBox(height: 20),
          const Image(
            image: AssetImage('images/character.png'),
            height: 130,
          ),
          const SizedBox(height: 40),
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
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Add Tasks'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTask()),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              child: const Text('View Completed Tasks'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CompletedTasks()));
              }),
        ])));
  }
}

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  CreateAddTaskState createState() => CreateAddTaskState();
}

class CreateAddTaskState extends State<AddTask> {
  final taskNameController = TextEditingController();
  final taskTextController = TextEditingController();
  final dateSetController = TextEditingController();
  final dateCompByController = TextEditingController();
  String helpText = "";
  bool isTaskBtnEnabled = false;

  @override
  void initState() {
    super.initState();
    taskNameController.addListener(_checkInput);
    dateSetController.addListener(_checkInput);
    dateCompByController.addListener(_checkInput);
  }

  @override
  void dispose() {
    taskNameController.dispose();
    dateSetController.dispose();
    dateCompByController.dispose();
    super.dispose();
  }

  void _checkInput() async {
    bool uniqueTaskName =
        await db.checkIfTaskNameExists(taskNameController.text);

    setState(() {
      isTaskBtnEnabled = uniqueTaskName;
      if (!uniqueTaskName) {
        helpText = "A task with that name already exists";
      } else {
        helpText = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // task name box
            const SizedBox(height: 20),
            TextFormField(
              controller: taskNameController,
              decoration: const InputDecoration(
                icon: Icon(Icons.notification_important_rounded),
                hintText: 'Please enter a name for the task',
              ),
            ),
            // date completed by
            const SizedBox(height: 20),
            TextFormField(
              controller: dateCompByController,
              decoration: const InputDecoration(
                icon: Icon(Icons.date_range),
                hintText: 'Please enter a date to complete the task by',
              ),
            ),
// Additional text widget to display static text
            const SizedBox(height: 20),
            Text(
              helpText,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 255, 0, 0)),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: isTaskBtnEnabled ? createTask : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isTaskBtnEnabled
                    ? const Color.fromARGB(255, 192, 129, 226)
                    : Colors.grey[400],
              ),
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  void createTask() async {
    String taskName = taskNameController.text;
    String dateCompBy = dateCompByController.text;

    db.Reminder r = db.Reminder(
      username: gUsername,
      reminderName: taskName,
      dateSet: TimeOfDay.now().toString(),
      dateCompletedBy: dateCompBy,
    );

    //print(r.toString());

    db.insertReminder(r);

    Navigator.pop(context);
  }
}

class CompletedTasks extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CompletedTasks({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do!'),
      ),
      body: FutureBuilder<List<DataRow>>(
        future: getTasksAsDataRows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: DataTable(
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
                rows: snapshot.data ?? [], // Use the data from the snapshot
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<DataRow>> getTasksAsDataRows() async {
    List<DataRow> tasksToDisplay = [];
    List<Map<String, dynamic>> reminders =
        await db.getRemindersForUser(gUsername);

    for (var reminder in reminders) {
      tasksToDisplay.add(DataRow(
        cells: [
          DataCell(Text(reminder['reminderName'])),
          DataCell(Text(reminder['dateSet'])),
          DataCell(Text(reminder['dateCompBy'])),
        ],
      ));
    }

    return tasksToDisplay;
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
          const SizedBox(height: 20),
          const Image(
            image: AssetImage('images/game.png'),
            height: 130,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            child: const Text('Play Game'),
            onPressed: () {},
          ),
          const SizedBox(height: 60),
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
