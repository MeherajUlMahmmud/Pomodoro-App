import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TimerPage extends StatefulWidget {
  static const routeName = '/timer-settings';

  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int workSessionDuration = 25;
  int shortBreakDuration = 5;
  int longBreakDuration = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Timer Settings'),
      ),
      body: ListView(
        children: [
          buildListTile('Work Session Duration', workSessionDuration, (value) {
            setState(() {
              workSessionDuration = value;
            });
          }),
          buildListTile('Short Break Duration', shortBreakDuration, (value) {
            setState(() {
              shortBreakDuration = value;
            });
          }),
          buildListTile('Long Break Duration', longBreakDuration, (value) {
            setState(() {
              longBreakDuration = value;
            });
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
                    onChanged: (value) {
                      // setState(() => currentValue =
                      //     value); // to change on widget level state
                      // SBsetState(() =>
                      //     currentValue = value); //* to change on dialog state
                    });
              }),
              actions: [
                TextButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
