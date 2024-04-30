import 'package:flutter/material.dart';
import 'package:capstone_test/db.dart' as db;
import 'package:capstone_test/screenTest.dart';
import 'package:capstone_test/Services/notifi_service.dart';
import 'package:capstone_test/homePage.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:date_sorting_algorithm/date_sorting_algorithm.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datatTimePicker;

// Page with calendar where user can add task and choose due date/time
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

                  // const SizedBox(height: 20),
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
