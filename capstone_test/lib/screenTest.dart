import 'dart:ffi';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:capstone_test/db.dart' as db;
import 'package:table_calendar/table_calendar.dart';

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

class TaskHome extends StatefulWidget {
  const TaskHome({Key? key}) : super(key: key);

  @override
  _TaskHomeState createState() => _TaskHomeState();
}

class _TaskHomeState extends State<TaskHome> {
  List<Map<String, dynamic>> reminders =
      []; // Initialize reminders as an empty list
  late List<bool> taskCompletionStatus;
  bool isLoading = true; // Flag to track loading status

  @override
  void initState() {
    super.initState();
    loadReminders();
  }

  Future<void> loadReminders() async {
    final loadedReminders = await db.getRemindersForUser(gUsername);
    setState(() {
      reminders = loadedReminders; // Update reminders with fetched data
      taskCompletionStatus = List.generate(reminders.length, (index) => false);
      isLoading =
          false; // Set loading status to false once reminders are loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getDate()),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  reminders.isEmpty
                      ? Center(
                          child: Text('No reminders'),
                        )
                      : DataTable(
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
                                  'Click to complete',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                          ],
                          rows: List.generate(reminders.length, (index) {
                            return DataRow(
                              cells: [
                                DataCell(Text(
                                    reminders[index]['reminderName'] ?? 'N/A')),
                                DataCell(Text(
                                    reminders[index]['dateCompBy'] ?? 'N/A')),
                                DataCell(
                                  Checkbox(
                                    value: taskCompletionStatus[index],
                                    onChanged: (newValue) {
                                      setState(() {
                                        taskCompletionStatus[index] = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Add Tasks'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTask(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  if (reminders.isNotEmpty)
                    ElevatedButton(
                      child: const Text('Complete Checked Tasks'),
                      onPressed: updateReminders,
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('View Completed Tasks'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompletedTasks(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  String getDate() {
    DateTime currDate = DateTime.now();
    String month = '';
    switch (currDate.month) {
      case 1:
        month = 'January';
        break;
      case 2:
        month = 'February';
        break;
      case 3:
        month = 'March';
        break;
      case 4:
        month = 'April';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'June';
        break;
      case 7:
        month = 'July';
        break;
      case 8:
        month = 'August';
        break;
      case 9:
        month = 'September';
        break;
      case 10:
        month = 'October';
        break;
      case 11:
        month = 'November';
        break;
      case 12:
        month = 'December';
        break;
      default:
        month = '';
    }

    String day = currDate.day.toString();
    String year = currDate.year.toString();
    String hour = currDate.hour.toString().padLeft(2, '0');
    String minute = currDate.minute.toString().padLeft(2, '0');

    return '$month $day, $year, $hour:$minute';
  }

  Future<void> updateReminders() async {
    for (int i = 0; i < reminders.length; i++) {
      if (taskCompletionStatus[i]) {
        String reminderName = reminders[i]['reminderName'];
        // Update reminder completion status in the database
        await db.updateCompletedReminder(reminderName);
      }
    }
    // Reload reminders after updating completion status
    await loadReminders();
  }
}

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  CreateAddTaskState createState() => CreateAddTaskState();
}

class CreateAddTaskState extends State<AddTask> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  final taskNameController = TextEditingController();
  final dateSetController = TextEditingController();
  final dateCompByController = TextEditingController();
  final timeCompyByController = TextEditingController();
  String helpText = "";
  bool isTaskBtnEnabled = false;

  @override
  void initState() {
    super.initState();
    taskNameController.addListener(_checkInput);
    dateSetController.addListener(_checkInput);
    dateCompByController.addListener(_checkInput);
    timeCompyByController.addListener(_checkInput);
  }

  @override
  void dispose() {
    taskNameController.dispose();
    dateSetController.dispose();
    dateCompByController.dispose();
    timeCompyByController.dispose();
    super.dispose();
  }

  void _checkInput() async {
    bool uniqueTaskName =
        await db.checkIfTaskNameExists(taskNameController.text);

    bool timeIsValid = RegExp("^([1-9]|1[0-2]):[0-5][0-9] [AP]M")
        .hasMatch(dateCompByController.text);

    bool tasknameLen = taskNameController.text.length < 20;

    setState(() {
      isTaskBtnEnabled = uniqueTaskName;
      if (!uniqueTaskName) {
        helpText = "A task with that name already exists";
      } else if (!tasknameLen) {
        helpText = "Please enter a shorter task name";
      } else if (!timeIsValid) {
        helpText = "Please enter a valid time in 12:00 AM/PM format";
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
            const SizedBox(height: 20),
            const Text("Please select a date to complete the task by"),
            // date comple
            TableCalendar(
              locale: "en-US",
              rowHeight: 43,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, today),
              focusedDay: today,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              onDaySelected: _onDaySelected,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: dateCompByController,
              decoration: const InputDecoration(
                icon: Icon(Icons.timer_outlined),
                hintText: "Please input a time",
              ),
            ),
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
              child: Text(today.toString()),
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
        dateSet: TimeOfDay.now().toString(), // TODO make this format better
        dateCompletedBy: today.month.toString() +
            " / " +
            today.day.toString() +
            "\n" +
            dateCompBy,
        isCompleted: 0);

    //print(r.toString());

    db.insertReminder(r);
    Navigator.pop(context, true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TaskHome()),
    );
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
