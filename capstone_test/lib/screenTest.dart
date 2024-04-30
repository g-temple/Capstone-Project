import 'package:capstone_test/Services/notifi_service.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:capstone_test/game.dart';
import 'package:capstone_test/db.dart' as db;
import 'package:capstone_test/createAccount.dart';
import 'package:capstone_test/logIn.dart';
import 'package:capstone_test/homePage.dart';
import 'package:capstone_test/addTask.dart';
import 'package:capstone_test/rewards.dart';
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

// Launches Welcome Page
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

//Welcome Page, user can select LogIn or Create Account
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
