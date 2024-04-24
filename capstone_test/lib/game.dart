import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

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
          title: Text('Snake Game'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                  context); // Navigate back when the arrow button is pressed
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
  static const int squaresPerRow = 10;
  static const int squaresPerColumn = 13;
  static const int totalSquares = squaresPerRow * squaresPerColumn;
  static const int refreshRate = 300;
  static const int gameOverDelayMilliseconds = 500;

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
    startGame();
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
    const duration = Duration(milliseconds: refreshRate);
    Timer.periodic(duration, (Timer timer) {
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
          Timer(Duration(milliseconds: gameOverDelayMilliseconds), () {
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Your score: ${snake.length - 3}'),
          actions: <Widget>[
            TextButton(
              child: Text('Play Again'),
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
                  direction = 'up';
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
      } else {
        snake.removeLast();
      }
    });
  }

  void changeDirection(String newDirection) {
    setState(() {
      direction = newDirection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Add padding to the top of the GridView
        SizedBox(height: 16),
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
                      NeverScrollableScrollPhysics(), // Disable vertical scrolling
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical:
                          8.0), // Add padding to the sides of the GridView
                  itemCount: totalSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
        SizedBox(height: 40),
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
            SizedBox(width: 20),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => changeDirection('up'),
                  child: Icon(Icons.arrow_upward),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => changeDirection('down'),
                  child: Icon(Icons.arrow_downward),
                ),
              ],
            ),
            SizedBox(width: 20),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => changeDirection('right'),
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
        // Add padding below the buttons to push them higher up
        SizedBox(height: 70),
      ],
    );
  }
}
