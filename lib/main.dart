import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            primaryColor: Colors.deepPurple,
            scaffoldBackgroundColor: const Color(0xFFF3E5F5),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.deepPurple),
              titleTextStyle: TextStyle(
                color: Colors.deepPurple,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          home: const TicTacToePage(),
        );
      },
    );
  }
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  Difficulty currentDifficulty = Difficulty.hard; // الافتراضي
  List<String> board = List.filled(9, '');
  final ai = TicTacToeMinimax();
  bool isGameOver = false;

  void handleTap(int index) {
    if (board[index] != '' || isGameOver) return;

    setState(() {
      board[index] = ai.humanSymbol;
      if (ai.checkWinner(board) == null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          // نمرر المستوى الحالي للدالة
          int bestMove = ai.getBestMove(board, currentDifficulty);
          if (bestMove != -1) {
            setState(() {
              board[bestMove] = ai.aiSymbol;
              _checkGameStatus();
            });
          }
        });
      } else {
        _checkGameStatus();
      }
    });
  }

  void _checkGameStatus() {
    String? winner = ai.checkWinner(board);
    if (winner != null) {
      isGameOver = true;
      String title = winner == 'Tie' ? "تعادل!" : "نهاية اللعبة!";
      String content = winner == 'Tie' ? "لم يفز أحد" : "الفائز هو: $winner";

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Game Over",
        pageBuilder: (context, anim1, anim2) {
          return const SizedBox(); // Not used but required
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
            scale: Curves.easeOutBack.transform(anim1.value),
            child: Opacity(
              opacity: anim1.value,
              child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  content,
                  style: TextStyle(color: Colors.deepPurple.shade300, fontSize: 18.sp),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _resetGame();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Text(
                          "العب مرة أخرى",
                          style: TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      );
    }
  }

  Widget _buildDifficultyButton(Difficulty difficulty, String label) {
    bool isSelected = currentDifficulty == difficulty;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentDifficulty = difficulty;
          _resetGame();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.deepPurple.shade300,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe AI"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)], // Light purple gradient
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: SnowWidget()),
            Column(
              children: [
                // أزرار اختيار المستوى
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withAlpha(25),
                        blurRadius: 10.r,
                        offset: Offset(0, 5.h),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDifficultyButton(Difficulty.easy, "سهل"),
                      _buildDifficultyButton(Difficulty.medium, "متوسط"),
                      _buildDifficultyButton(Difficulty.hard, "صعب"),
                    ],
                  ),
                ),

                SizedBox(height: 50.h),

                // الشبكة (Grid)
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(20.r),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15.w,
                      mainAxisSpacing: 15.h,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => handleTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withAlpha(25),
                                blurRadius: 8.r,
                                offset: Offset(4.w, 4.h),
                              ),
                              BoxShadow(
                                color: Colors.white.withAlpha(128),
                                blurRadius: 8.r,
                                offset: Offset(-4.w, -4.h),
                              ),
                            ],
                          ),
                          child: Center(
                            child: board[index] == ''
                                ? const SizedBox()
                                : TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.elasticOut,
                                    builder: (context, scale, child) {
                                      return Transform.scale(
                                        scale: scale,
                                        child: Text(
                                          board[index],
                                          style: TextStyle(
                                            fontSize: 60.sp,
                                            fontWeight: FontWeight.bold,
                                            color: board[index] == ai.aiSymbol
                                                ? Colors.purpleAccent
                                                : Colors.deepPurple,
                                            shadows: [
                                              Shadow(
                                                color: board[index] == ai.aiSymbol
                                                    ? Colors.purpleAccent.withAlpha(50)
                                                    : Colors.deepPurple.withAlpha(50),
                                                blurRadius: 10.r,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: ElevatedButton.icon(
                    onPressed: _resetGame,
                    icon: Icon(Icons.refresh, color: Colors.white, size: 24.sp),
                    label: Text(
                      "إعادة اللعب",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 15.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      isGameOver = false;
    });
  }
}

enum Difficulty { easy, medium, hard }

class TicTacToeMinimax {
  final String aiSymbol;
  final String humanSymbol;
  final String emptySymbol;

  TicTacToeMinimax({
    this.aiSymbol = 'X',
    this.humanSymbol = 'O',
    this.emptySymbol = '',
  });

  String? checkWinner(List<String> board) {
    const winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var condition in winConditions) {
      if (board[condition[0]] == board[condition[1]] &&
          board[condition[0]] == board[condition[2]] &&
          board[condition[0]] != emptySymbol) {
        return board[condition[0]];
      }
    }

    if (!board.contains(emptySymbol)) return 'Tie';
    return null;
  }

  int minimax(
    List<String> board,
    int depth,
    bool isMaximizing, [
    double alpha = -double.infinity,
    double beta = double.infinity,
  ]) {
    String? winner = checkWinner(board);
    if (winner == aiSymbol) return 10 - depth;
    if (winner == humanSymbol) return depth - 10;
    if (winner == 'Tie') return 0;

    if (isMaximizing) {
      int maxEval = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == emptySymbol) {
          board[i] = aiSymbol;
          int eval = minimax(board, depth + 1, false, alpha, beta);
          board[i] = emptySymbol;
          maxEval = max(maxEval, eval);
          alpha = max(alpha, eval.toDouble());
          if (beta <= alpha) break;
        }
      }
      return maxEval;
    } else {
      int minEval = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == emptySymbol) {
          board[i] = humanSymbol;
          int eval = minimax(board, depth + 1, true, alpha, beta);
          board[i] = emptySymbol;
          minEval = min(minEval, eval);
          beta = min(beta, eval.toDouble());
          if (beta <= alpha) break;
        }
      }
      return minEval;
    }
  }

  int getBestMove(List<String> board, Difficulty difficulty) {
    Random random = Random();
    int threshold;

    switch (difficulty) {
      case Difficulty.easy:
        threshold = 20; // 20% ذكاء
        break;
      case Difficulty.medium:
        threshold = 50; // 50% ذكاء
        break;
      case Difficulty.hard:
        threshold = 100; // 100% ذكاء
        break;
    }

    if (random.nextInt(100) < threshold) {
      return _calculateBestMove(board);
    } else {
      List<int> availableMoves = [];
      for (int i = 0; i < 9; i++) {
        if (board[i] == emptySymbol) availableMoves.add(i);
      }
      return availableMoves[random.nextInt(availableMoves.length)];
    }
  }

  int _calculateBestMove(List<String> board) {
    int bestVal = -1000;
    int bestMove = -1;

    if (board.where((e) => e == emptySymbol).length == 9) return 4;

    for (int i = 0; i < 9; i++) {
      if (board[i] == emptySymbol) {
        board[i] = aiSymbol;
        int moveVal = minimax(board, 0, false);
        board[i] = emptySymbol;

        if (moveVal > bestVal) {
          bestMove = i;
          bestVal = moveVal;
        }
      }
    }
    return bestMove;
  }
}

class Snowflake {
  double x;
  double y;
  double radius;
  double speed;
  double opacity;

  Snowflake(this.x, this.y, this.radius, this.speed, this.opacity);
}

class SnowWidget extends StatefulWidget {
  const SnowWidget({super.key});

  @override
  State<SnowWidget> createState() => _SnowWidgetState();
}

class _SnowWidgetState extends State<SnowWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Snowflake> _snowflakes = [];
  final Random _random = Random();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 1))..addListener(() {
      setState(() {
        _updateSnowflakes();
      });
    })..repeat();
  }

  void _initSnowflakes(Size size) {
    if (_initialized) return;
    for (int i = 0; i < 100; i++) {
      _snowflakes.add(
        Snowflake(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
          _random.nextDouble() * 2 + 1, // radius 1-3
          _random.nextDouble() * 2 + 1, // speed 1-3
          _random.nextDouble() * 0.5 + 0.2, // opacity 0.2-0.7
        ),
      );
    }
    _initialized = true;
  }

  void _updateSnowflakes() {
    final Size size = MediaQuery.of(context).size;
    for (var flake in _snowflakes) {
      flake.y += flake.speed;
      if (flake.y > size.height) {
        flake.y = -flake.radius;
        flake.x = _random.nextDouble() * size.width;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!_initialized && size.width > 0) {
      _initSnowflakes(size);
    }
    return CustomPaint(
      size: Size.infinite,
      painter: SnowPainter(_snowflakes),
    );
  }
}

class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;

  SnowPainter(this.snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var flake in snowflakes) {
      final paint = Paint()
        ..color = Colors.white.withAlpha((flake.opacity * 255).toInt())
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(flake.x, flake.y), flake.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
