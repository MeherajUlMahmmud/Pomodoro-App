import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pomodoro/utils/local_storage.dart';

class TimerPage extends StatefulWidget {
  static const routeName = '/timer-settings';

  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  String token = '';

  TextEditingController titleController = TextEditingController();

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  Map<String, dynamic> initialTimerData = {
    'workSessionDuration': 25,
    'shortBreakDuration': 5,
    'longBreakDuration': 15,
  };
  Map<String, dynamic> updatedTimerData = {
    'workSessionDuration': 25,
    'shortBreakDuration': 5,
    'longBreakDuration': 15,
  };

  @override
  void initState() {
    super.initState();

    readTokensAndUser();
  }

  readTokensAndUser() async {
    token = await localStorage.readStringData('token');
    user = await localStorage.readData('user');

    setState(() {
      initialTimerData = {
        'workSessionDuration': user['timerData']['workSessionDuration'],
        'shortBreakDuration': user['timerData']['shortBreakDuration'],
        'longBreakDuration': user['timerData']['longBreakDuration'],
      };

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Timer Settings'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : ListView(
              children: [
                buildListTile('Work Session Duration',
                    initialTimerData['workSessionDuration'], (value) {
                  setState(() {
                    updatedTimerData['workSessionDuration'] = value;
                  });
                  print(updatedTimerData);
                }),
                buildListTile('Short Break Duration',
                    initialTimerData['shortBreakDuration'], (value) {
                  setState(() {
                    updatedTimerData['shortBreakDuration'] = value;
                  });
                  print(updatedTimerData);
                }),
                buildListTile('Long Break Duration',
                    initialTimerData['longBreakDuration'], (value) {
                  setState(() {
                    updatedTimerData['longBreakDuration'] = value;
                  });
                  print(updatedTimerData);
                }),
              ],
            ),
    );
  }

  Widget buildListTile(String title, int value, Function(int) onChanged) {
    return GestureDetector(
      onTap: () async {
        int? newValue = await showDialog<int>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(child: Text(title)),
              content: StatefulBuilder(builder: (context, SBsetState) {
                return NumberPicker(
                  selectedTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  value: value,
                  minValue: 1,
                  maxValue: 60,
                  onChanged: onChanged,
                );
              }),
              actions: [
                TextButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      child: ListTile(
        title: Text(title),
        trailing: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'min',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
