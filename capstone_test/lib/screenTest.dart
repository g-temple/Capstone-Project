import 'package:capstone_test/Services/notifi_service.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:capstone_test/game.dart';
import 'package:capstone_test/db.dart' as db;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/rendering.dart';
import 'package:date_sorting_algorithm/date_sorting_algorithm.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datatTimePicker;

// global variable to reference for creating and updating tasks
String gUsername = "";
bool hasCompletedTask = false;
DateTime scheduleTime = DateTime.now();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
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
        toolbarHeight: 40,
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
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 157,
                    height: 41,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateAccount()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff8491d9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      child: const Text('Create Account',
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              fontFamily: "OpenSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.center),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 157,
                    height: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogIn()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff8491d9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      child: const Text(
                          'Have an Account?\n '
                          'Log In',
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              fontFamily: "OpenSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.center),
                    ),
                  )
                ],
              )),
            ),
          ),
        ],
      ),
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> reminders =
      []; // Initialize reminders as an empty list
  late List<bool> taskCompletionStatus;
  List<Map<String, dynamic>> dueDate = [];

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
          toolbarHeight: 40,
          leading: IconButton(
            icon: const Icon(Icons.account_circle),
            iconSize: 30,
            color: Colors.indigo.shade400,
            onPressed: () async {
              // Show a confirmation dialog
              bool exitConfirmed = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Log Out?'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                              false); // Return false when cancel button is pressed
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                              true); // Return true when exit button is pressed
                        },
                        child: const Text('Log Out'),
                      ),
                    ],
                  );
                },
              );

              // If the user confirms exit, pop the current route
              if (exitConfirmed == true) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(47)),

                child: Center(
                    child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    SizedBox(
                      child: Container(
                          alignment: Alignment.center,
                          width: 314,
                          height: 138,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: Color(0xffabb5ef)),
                          child: Text(
                            'Welcome $gUsername',
                            style: const TextStyle(
                                color: Color(0xffffffff),
                                fontWeight: FontWeight.w700,
                                fontFamily: "Inter",
                                fontStyle: FontStyle.normal,
                                fontSize: 25.0),
                            textAlign: TextAlign.center,
                          )),
                    ),
                    // const Image(
                    //   image: AssetImage('images/character.png'),
                    //   height: 130,
                    // ),

                    const SizedBox(height: 40),
                    SizedBox(
                      width: 315,
                      child: SingleChildScrollView(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: reminders.isEmpty
                              ? const Center(
                                  child: Text('No reminders'),
                                )
                              : DataTable(
                                  border: const TableBorder(
                                      horizontalInside: BorderSide(
                                          width: 1,
                                          color: Color(0xfffd7e7e),
                                          style: BorderStyle.solid)),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(
                                        253, 126, 126, 0.19),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  columnSpacing: 10.0,
                                  sortColumnIndex: 2,
                                  sortAscending: true,
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Task',
                                          // style: TextStyle(
                                          //     fontStyle: FontStyle.italic),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Do By',
                                          // style: TextStyle(
                                          //     fontStyle: FontStyle.italic),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Complete',
                                          // style: TextStyle(
                                          //     fontStyle: FontStyle.italic),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => const Color(0xfffd7e7e)),
                                  headingTextStyle: const TextStyle(
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Inter",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                  rows:
                                      List.generate(reminders.length, (index) {
                                    // String inputDateFormat = 'dd.MM.yyyy';
                                    // SortList sortList = SortList().sortByDate(reminders.dateCompletedBy, inputDateFormat);
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(reminders[index]
                                                  ['reminderName'] ??
                                              'N/A'),
                                        ),
                                        DataCell(Text(reminders[index]
                                                ['dateCompBy'] ??
                                            'N/A')),
                                        DataCell(
                                          Checkbox(
                                            value: taskCompletionStatus[index],
                                            onChanged: (newValue) {
                                              setState(() {
                                                taskCompletionStatus[index] =
                                                    newValue!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    if (reminders.isNotEmpty)
                      ElevatedButton(
                        onPressed: updateReminders,
                        child: const Text('Complete Checked Tasks'),
                      ),
                    const SizedBox(height: 20),

                    const SizedBox(height: 40),
                    SizedBox(
                      height: 75,
                      width: 151,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffabb5ef),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12)), // Button border radius
                        ),
                        child: const Text(
                          'Rewards',
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Inter",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RewardsHome()),
                          );
                        },
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ],
        ));
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
    hasCompletedTask = true;
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
    _checkInput();
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

    bool timeIsValid = RegExp("^(0[1-9]|1[0-2]):[0-5][0-9] (AM|am|PM|pm)")
        .hasMatch(timeCompyByController.text);

    int hoursToAdd = 0;
    int minsToAdd = 0;

    if (timeIsValid) {
      hoursToAdd = int.parse(timeCompyByController.text.split(":")[0]);

      List<String> dateData =
          timeCompyByController.text.split(":")[1].split(" ");
      minsToAdd = int.parse(dateData[0]);

      hoursToAdd += dateData[1].contains(RegExp("(PM|pm)")) ? 12 : 0;
      print(hoursToAdd);
    }

    bool isInFuture = isDateTimeInFuture(
        today.add(Duration(hours: hoursToAdd, minutes: minsToAdd)),
        DateTime.now());

    setState(() {
      isTaskBtnEnabled = uniqueTaskName && timeIsValid && isInFuture;
      if (!uniqueTaskName) {
        helpText = "A task with that name already exists";
      } else if (!timeIsValid) {
        helpText = "Please enter time in the 00:00 AM/PM format";
      } else if (!isInFuture) {
        helpText = "Please enter time in the future";
      } else {
        helpText = "";
      }
      print(isTaskBtnEnabled);
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
                  Container(
                      width: 347,
                      height: 91,
                      decoration: const BoxDecoration(
                        color: Color(0xff8491d9),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                      ),
                      child: const Center(
                          child: Text("Create Task",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "OpenSans",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0)))),
                  // task name box
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 60,
                    width: 296,
                    child: TextFormField(
                      maxLength: 29,
                      controller: taskNameController,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      showCursor: false,
                      //controller: ageController,
                      decoration: InputDecoration(
                        hintText: "Task Name",
                        hintStyle: const TextStyle(
                            color: Color(0xff8491d9),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
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
                        isDense: true,
                        // Added this
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  // const Text("Date"),
                  // date comple
                  TableCalendar(
                    locale: "en-US",
                    rowHeight: 43,
                    headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.normal,
                            fontFamily: "OpenSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0),
                        decoration: BoxDecoration(color: Color(0xff8491d9))),
                    availableGestures: AvailableGestures.all,
                    selectedDayPredicate: (day) => isSameDay(day, today),
                    focusedDay: today,
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    onDaySelected: _onDaySelected,
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    height: 34,
                    width: 296,
                    child: TextFormField(
                      controller: timeCompyByController,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      showCursor: false,
                      //controller: ageController,
                      decoration: InputDecoration(
                        hintText: "Time Due",
                        hintStyle: const TextStyle(
                            color: Color(0xff8491d9),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
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
                  Text(
                    helpText,
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 255, 0, 0)),
                  ),

                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: isTaskBtnEnabled ? createTask : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isTaskBtnEnabled
                          ? const Color.fromARGB(255, 192, 129, 226)
                          : Colors.grey[400],
                    ),
                    child: const Text("Add Task"),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }

  void createTask() async {
    String taskName = taskNameController.text;
    String timeCompBy = timeCompyByController.text;

    int hoursToAdd = int.parse(timeCompyByController.text.split(":")[0]);

    List<String> dateData = timeCompyByController.text.split(":")[1].split(" ");
    int minsToAdd = int.parse(dateData[0]);

    hoursToAdd += dateData[1].contains(RegExp("(PM|pm)")) ? 12 : 0;

    DateTime notifBy =
        DateTime(today.year, today.month, today.day, hoursToAdd, minsToAdd);

    notifBy = notifBy.subtract(const Duration(minutes: 1));

    NotificationService().scheduleNotification(
        title: 'Scheduled Notification',
        body: 'Finish task $taskName',
        scheduledNotificationDateTime: notifBy);

    db.Reminder r = db.Reminder(
        username: gUsername,
        reminderName: taskName,
        dateSet: DateTime.now().toString(),
        dateCompletedBy: "${today.month}/${today.day}\n$timeCompBy",
        isCompleted: 0);

    //print(r.toString());

    db.insertReminder(r);
    Navigator.pop(context, true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  bool isDateTimeInFuture(
      DateTime dateTimeToCheck, DateTime referenceDateTime) {
    if (dateTimeToCheck.year > referenceDateTime.year) {
      return true;
    } else if (dateTimeToCheck.year < referenceDateTime.year) {
      return false;
    }

    // Year is equal, check month
    if (dateTimeToCheck.month > referenceDateTime.month) {
      return true;
    } else if (dateTimeToCheck.month < referenceDateTime.month) {
      return false;
    }

    // Month is equal, check day
    if (dateTimeToCheck.day > referenceDateTime.day) {
      return true;
    } else if (dateTimeToCheck.day < referenceDateTime.day) {
      return false;
    }

    // Day is equal, check hour
    if (dateTimeToCheck.hour > referenceDateTime.hour) {
      return true;
    } else if (dateTimeToCheck.hour < referenceDateTime.hour) {
      return false;
    }

    // Hour is equal, check minute
    if (dateTimeToCheck.minute > referenceDateTime.minute) {
      return true;
    } else if (dateTimeToCheck.minute < referenceDateTime.minute) {
      return false;
    }

    // At this point, both DateTime objects are equal
    return false;
  }
}

/*
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
          child: TableCalendar(
        locale: "en-US",
        rowHeight: 43,
        headerStyle:
            const HeaderStyle(formatButtonVisible: false, titleCentered: true),
        availableGestures: AvailableGestures.all,
        selectedDayPredicate: (day) => isSameDay(day, today),
        focusedDay: today,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        onDaySelected: _onDaySelected,
      )),
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
*/
class CompletedTasks extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CompletedTasks({Key? key});

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
          DataCell(Text(reminder['dateCompBy'])),
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
                  const SizedBox(height: 70),
                  ClipRRect(
                    child: Image(
                      image: AssetImage('images/SNAKEGame.png'),
                      height: 450,
                    ),
                    borderRadius: BorderRadius.circular(47),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    child: const Text(
                      'Play Game',
                      style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.normal,
                          fontFamily: "OpenSans",
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasCompletedTask
                          ? const Color.fromARGB(255, 192, 129, 226)
                          : Colors.grey[400],
                    ),
                    onPressed: () {
                      if (hasCompletedTask) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SnakeGame()),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Cannot play game'),
                              content: const Text(
                                  'You must have completed a task recently to play a game'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Dismiss the dialog
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 60),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
