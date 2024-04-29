import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

bool isGameOver = false;

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Snake Game'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (isGameOver) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SnakeGameScreen(),
      ),
    );
  }
}

class SnakeGameScreen extends StatefulWidget {
  @override
  _SnakeGameScreenState createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  late Timer _timer;
  static const int squaresPerRow = 10;
  static const int squaresPerColumn = 13;
  static const int totalSquares = squaresPerRow * squaresPerColumn;
  static const int refreshRate = 300;
  static const int gameOverDelayMilliseconds = 500;
  int score = 0;

  static List<int> snake = [
    (totalSquares ~/ 2) + squaresPerRow + (squaresPerRow ~/ 2) - 1,
    (totalSquares ~/ 2) + squaresPerRow + (squaresPerRow ~/ 2),
    (totalSquares ~/ 2) + squaresPerRow + (squaresPerRow ~/ 2) + 1
  ];
  static int food = Random().nextInt(totalSquares);

  var direction = 'up';
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      snake.clear();
      snake = [
        (totalSquares ~/ 2) + squaresPerRow + (squaresPerRow ~/ 2) - 1,
        (totalSquares ~/ 2) + squaresPerRow + (squaresPerRow ~/ 2),
        (totalSquares ~/ 2) + squaresPerRow + (squaresPerRow ~/ 2) + 1
      ];
      food = Random().nextInt(totalSquares);
      final List<String> directions = ['up', 'down', 'left', 'right'];
      final Random random = Random();
      direction = directions[random.nextInt(directions.length)];
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructionsDialog();
    });
    //startGame();
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the timer when the screen is disposed
    _timer.cancel();
  }

  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Instructions'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instructions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('- Swipe up, down, left, or right to move the snake.'),
              Text('- Or use the arrow keys.'),
              Text('- Eat the red square to grow.'),
              Text('- Avoid hitting the walls or the snake itself.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  bool checkGameOver() {
    if (snake.first < 0 ||
        snake.first >= totalSquares ||
        snake.sublist(1).contains(snake.first) ||
        (direction == 'up' && snake.first < squaresPerRow) ||
        (direction == 'down' && snake.first >= totalSquares - squaresPerRow) ||
        (direction == 'left' && snake.first % squaresPerRow == 0) ||
        (direction == 'right' && (snake.first + 1) % squaresPerRow == 0)) {
      return true;
    }
    return false;
  }

  void startGame() {
    isGameOver = false;
    const duration = Duration(milliseconds: refreshRate);
    _timer = Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (checkGameOver()) {
        timer.cancel();
        if (snake.first < 0 ||
            snake.first >= totalSquares ||
            snake.sublist(1).contains(snake.first)) {
          // If the snake hits itself or goes out of bounds, show game over immediately
          showGameOverDialog();
        } else {
          // If the snake hits the edge, delay showing game over dialog
          Timer(const Duration(milliseconds: gameOverDelayMilliseconds), () {
            if (checkGameOver()) {
              // Check game over again after the delay
              showGameOverDialog();
            } else {
              // If the player changes direction before the delay ends, continue the game
              timer.cancel();
              startGame();
            }
          });
        }
      }
      setState(() {});
    });
  }

  void showGameOverDialog() {
    isGameOver = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score: ${snake.length - 3}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Go Home'),
            ),
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                setState(() {
                  snake.clear();
                  snake = [
                    (totalSquares ~/ 2) +
                        squaresPerRow +
                        (squaresPerRow ~/ 2) -
                        1,
                    (totalSquares ~/ 2) + squaresPerRow + (squaresPerRow ~/ 2),
                    (totalSquares ~/ 2) +
                        squaresPerRow +
                        (squaresPerRow ~/ 2) +
                        1
                  ];
                  food = Random().nextInt(totalSquares);
                  final List<String> directions = [
                    'up',
                    'down',
                    'left',
                    'right'
                  ];
                  final Random random = Random();
                  direction = directions[random.nextInt(directions.length)];
                });
                Navigator.of(context).pop();
                startGame();
              },
            ),
          ],
        );
      },
    );
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'up':
          if (snake.first < squaresPerRow) {
            snake.insert(0, snake.first + totalSquares - squaresPerRow);
          } else {
            snake.insert(0, snake.first - squaresPerRow);
          }
          break;
        case 'down':
          if (snake.first >= totalSquares - squaresPerRow) {
            snake.insert(0, snake.first - totalSquares + squaresPerRow);
          } else {
            snake.insert(0, snake.first + squaresPerRow);
          }
          break;
        case 'left':
          if (snake.first % squaresPerRow == 0) {
            snake.insert(0, snake.first + squaresPerRow - 1);
          } else {
            snake.insert(0, snake.first - 1);
          }
          break;
        case 'right':
          if ((snake.first + 1) % squaresPerRow == 0) {
            snake.insert(0, snake.first - squaresPerRow + 1);
          } else {
            snake.insert(0, snake.first + 1);
          }
          break;
      }
      if (snake.first == food) {
        food = Random().nextInt(totalSquares);
        score++;
      } else {
        snake.removeLast();
      }
    });
  }

  void changeDirection(String newDirection) {
    if (direction == 'up' && newDirection == 'down') {
      return;
    }
    if (direction == 'right' && newDirection == 'left') {
      return;
    }
    if (direction == 'left' && newDirection == 'right') {
      return;
    }
    if (direction == 'down' && newDirection == 'up') {
      return;
    } else {
      setState(() {
        direction = newDirection;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        // Add padding to the top of the GridView
        const SizedBox(height: 10),
        Expanded(
          child: Listener(
            onPointerDown: (_) => FocusScope.of(context)
                .requestFocus(FocusNode()), // Disable keyboard
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! < 0 && direction != 'down') {
                  changeDirection('up');
                } else if (details.primaryDelta! > 0 && direction != 'up') {
                  changeDirection('down');
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.primaryDelta! > 0 && direction != 'left') {
                  changeDirection('right');
                } else if (details.primaryDelta! < 0 && direction != 'right') {
                  changeDirection('left');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.purple,
                      width: 3.0), // Add border to the container
                ),
                child: GridView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable vertical scrolling
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical:
                          8.0), // Add padding to the sides of the GridView
                  itemCount: totalSquares,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: squaresPerRow,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (snake.contains(index)) {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      );
                    } else if (index == food) {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.grey[200],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        // Arrange the buttons in the desired formation
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => changeDirection('left'),
                  child: Icon(Icons.arrow_back),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => changeDirection('up'),
                  child: const Icon(Icons.arrow_upward),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => changeDirection('down'),
                  child: const Icon(Icons.arrow_downward),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => changeDirection('right'),
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
        // Add padding below the buttons to push them higher up
        const SizedBox(height: 70),
      ],
    );
  }
}
