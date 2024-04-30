import 'package:flutter/material.dart';
import 'package:capstone_test/db.dart' as db;
import 'package:capstone_test/screenTest.dart';
import 'package:capstone_test/Services/notifi_service.dart';
import 'package:capstone_test/homePage.dart';
import 'package:capstone_test/game.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:date_sorting_algorithm/date_sorting_algorithm.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datatTimePicker;

// Page where user can select to play game IF they have met the task completion condition
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
            hasCompletedTask = false;
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
