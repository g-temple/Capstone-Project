import 'package:flutter/material.dart';

void main() {
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

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Return Home'),
        ),
      ),
    );
  }
}

class LogIn extends StatelessWidget {
  const LogIn({super.key});

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
              decoration: const InputDecoration(
                  icon: Icon(Icons.person), hintText: 'Enter Username'),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                  icon: Icon(Icons.key), hintText: 'Enter Password'),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              child: const Text('Log In'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            )
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