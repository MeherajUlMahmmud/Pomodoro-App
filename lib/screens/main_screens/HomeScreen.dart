import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:pomodoro/screens/utility_screens/SettingsScreen.dart';
import 'package:pomodoro/screens/main_screens/StatisticsScreen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/timer';

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _duration = 10;

  bool _isWorkSession = false;
  bool _isTimerRunning = false;
  bool _isTimerPaused = false;
  bool _hasTimerEnded = false;

  final CountDownController _controller = CountDownController();

  void _startTimer(String title, int duration) {
    debugPrint('Timer started');
    setState(() {
      _duration = duration * 60;
      _isTimerRunning = true;
      _isWorkSession = title == "Work Session" ? true : false;
    });

    _controller.restart(duration: duration);
    // _controller.start();
  }

  void _pauseTimer() {
    debugPrint('Timer paused');
    setState(() {
      _isTimerPaused = true;
    });
    _controller.pause();
  }

  void _resumeTimer() {
    debugPrint('Timer resumed');
    setState(() {
      _isTimerPaused = false;
    });
    _controller.resume();
  }

  void _resetTimer() {
    debugPrint('Timer reset');
    setState(() {
      _isTimerRunning = false;
      _isTimerPaused = false;
    });
    _controller.reset();
  }

  void _onComplete() {
    debugPrint('Countdown Ended');
    setState(() {
      _isTimerRunning = false;
      _isTimerPaused = false;
      // _hasTimerEnded = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Pomodoro Timer'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, StatisticsScreen.routeName);
            },
            icon: const Icon(Icons.bar_chart),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          _isTimerRunning
              ? Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isWorkSession ? 'Work Session' : 'Break Session',
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Icon(
                          _isWorkSession
                              ? Icons.desktop_mac_rounded
                              : Icons.free_breakfast_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        CircularCountDownTimer(
                          duration: _duration,
                          initialDuration: 0,
                          controller: _controller,
                          // width: MediaQuery.of(context).size.width / 2,
                          // height: MediaQuery.of(context).size.height / 2,
                          width: 150,
                          height: 150,
                          ringColor: Colors.white,
                          ringGradient: null,
                          fillColor: Theme.of(context).primaryColor,
                          // fillGradient: null,
                          // backgroundColor: Colors.purple[500],
                          // backgroundGradient: null,
                          strokeWidth: 8.0,
                          strokeCap: StrokeCap.round,
                          textStyle: const TextStyle(
                            fontSize: 28.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textFormat: CountdownTextFormat.MM_SS,
                          isReverse: true,
                          isReverseAnimation: false,
                          isTimerTextShown: true,
                          autoStart: true,
                          onStart: () {
                            debugPrint('Countdown Started');
                          },
                          onComplete: _onComplete,
                          onChange: (String timeStamp) {
                            debugPrint('Countdown Changed $timeStamp');
                          },
                          timeFormatterFunction:
                              (defaultFormatterFunction, duration) {
                            if (duration.inSeconds == 0) {
                              return "Start";
                            } else {
                              return Function.apply(
                                defaultFormatterFunction,
                                [duration],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !_isTimerPaused
                                ? Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _pauseTimer();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Icon(
                                            Icons.pause,
                                            size: 30,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Pause',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            _isTimerPaused
                                ? Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _resumeTimer();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Icon(
                                            Icons.play_arrow,
                                            size: 30,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Resume',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _resetTimer();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(
                                      Icons.replay,
                                      size: 30,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : _hasTimerEnded
                  ? const SizedBox()
                  : Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildTimerVariant('Work Session', 25, context),
                                const SizedBox(width: 5),
                                buildTimerVariant('Long Break', 10, context),
                                const SizedBox(width: 5),
                                buildTimerVariant('Short Break', 5, context),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Icon(
                              Icons.timer,
                              size: 200,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            Text(
                              'Feeling Motivated?',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Start a Work Session',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Or',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Take a Break',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget buildTimerVariant(String title, int duration, BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        _startTimer(title, _duration);
      },
      child: Container(
        width: width * 0.3,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  duration.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'min',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
