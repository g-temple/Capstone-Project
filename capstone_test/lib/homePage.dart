import 'package:flutter/material.dart';
import 'package:capstone_test/db.dart' as db;
import 'package:capstone_test/screenTest.dart';
import 'package:capstone_test/Services/notifi_service.dart';
import 'package:capstone_test/homePage.dart';
import 'package:capstone_test/game.dart';
import 'package:capstone_test/rewards.dart';
import 'package:capstone_test/addTask.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:date_sorting_algorithm/date_sorting_algorithm.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datatTimePicker;

// Home page onc a user logs in, from here they can view tasks, add tasks, or check rewards page
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
