import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';

class TimerScreen extends StatefulWidget {
  static const routeName = '/timer';

  const TimerScreen({super.key});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _duration = 0;
  int _currentTime = 0;

  bool _isWorkSession = false;
  bool _isTimerRunning = false;
  bool _isTimerPaused = false;
  bool _hasTimerEnded = false;

  void _pauseTimer() {
    print('Timer paused');
    setState(() {
      _isTimerPaused = true;
    });
  }

  void _resumeTimer() {
    print('Timer resumed');
    setState(() {
      _isTimerPaused = false;
    });
  }

  void _resetTimer() {
    print('Timer reset');
    setState(() {
      _isTimerRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            _isTimerRunning
                ? Expanded(
                    child: Container(
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
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Icon(
                            _isWorkSession
                                ? Icons.desktop_mac_rounded
                                : Icons.free_breakfast_rounded,
                            size: 70,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 20),
                          CountdownTimer(
                            controller: CountdownTimerController(
                              endTime: DateTime.now().millisecondsSinceEpoch +
                                  1000 * _duration,
                              onEnd: () {
                                print('Timer ended');
                              },
                            ),
                            widgetBuilder: (_, CurrentRemainingTime? time) {
                              if (time == null) {
                                return const Text(
                                  '00:00',
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }
                              return Text(
                                '${time.min ?? 0}:${time.sec}',
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              !_isTimerPaused // this means timer is running
                                  ? Column(
                                      // pause button
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
                                              size: 35,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Pause',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              _isTimerPaused // this means timer is paused
                                  ? Column(
                                      // resume button
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _resumeTimer();
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
                                              Icons.play_arrow,
                                              size: 35,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Resume',
                                          style: TextStyle(
                                            fontSize: 20,
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
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Icon(
                                        Icons.replay,
                                        size: 35,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Reset',
                                    style: TextStyle(
                                      fontSize: 20,
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
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildTimerVariant(
                                      'Work Session', 25, context),
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
      ),
    );
  }

  Widget buildTimerVariant(String title, int duration, BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          _duration = duration * 60;
          _currentTime = _duration;
          _isTimerRunning = true;
          _isWorkSession = title == "Work Session" ? true : false;
        });
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
