import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productivity_timer/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Container(
        child: Settings(),
      ),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() {
    return _SettingsState();
  }

}

class _SettingsState extends State<Settings> {
  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";
  int? workTime;
  int? shortBreak;
  int? longBreak;

  late SharedPreferences prefs;

  TextStyle textStyle = const TextStyle(fontSize: 24);
  late TextEditingController txtWork;
  late TextEditingController txtShort;
  late TextEditingController txtLong;

  @override
  void initState() {
    txtWork = TextEditingController();
    txtShort = TextEditingController();
    txtLong = TextEditingController();
    readSettings();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(crossAxisCount: 3,
        scrollDirection: Axis.vertical,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          Text("Work", style: textStyle),
          const Text(""),
          const Text(""),
          SettingsButton(const Color(0xff455A64), "-", -1, WORKTIME, updateSetting ),
          TextField(
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: txtWork,
          ),
          SettingsButton(const Color(0xff009688), "+", 1, WORKTIME, updateSetting ),
          Text("Short", style: textStyle),
          Text(""),
          Text(""),
          SettingsButton(const Color(0xff455a64), "-", -1, SHORTBREAK, updateSetting ),
          TextField(
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: txtShort,
          ),
          SettingsButton(const Color(0xff009688), "+", 1, SHORTBREAK, updateSetting ),
          Text("Long", style: textStyle),
          Text(""),
          Text(""),
          SettingsButton(Color(0xff455a64), "-", -1, LONGBREAK, updateSetting ),
          TextField(
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: txtLong,
          ),
          SettingsButton(Color(0xff009688), "+", 1, LONGBREAK, updateSetting ),

        ],
        padding: EdgeInsets.all(20.0),
      ),
    );
  }

  void readSettings() async {
    prefs = await SharedPreferences.getInstance();
    int? workTime = prefs.getInt(WORKTIME);
    if (workTime == null) {
      await prefs.setInt(WORKTIME, int.parse('30'));
    }
    int? shortBreak = prefs.getInt(SHORTBREAK);
    if (shortBreak == null) {
      await prefs.setInt(SHORTBREAK, int.parse('5'));
    }
    int? longBreak = prefs.getInt(LONGBREAK);
    if (longBreak == null) {
      await prefs.setInt(LONGBREAK, int.parse('20'));
    }
    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  void updateSetting(String key, int value) {
    switch(key) {
      case WORKTIME:
        {
          int? workTime = prefs.getInt(WORKTIME);
          workTime = (workTime != null) ? workTime + value : null;
          if (workTime != null && workTime >= 1 && workTime <= 180) {
            prefs.setInt(WORKTIME, workTime);
            setState(() {
              txtWork.text = workTime.toString();
            });
          }
        }
        break;
      case SHORTBREAK:
        {
          int? short = prefs.getInt(SHORTBREAK);
          short = (short != null) ? short + value : null;
          if (short != null && short >= 1 && short <= 180) {
            prefs.setInt(SHORTBREAK, short);
            setState(() {
              txtShort.text = short.toString();
            });
          }
        }
        break;
      case LONGBREAK:
        {
          int? long = prefs.getInt(LONGBREAK);
          long = (long != null) ? long + value : null;
          if (long != null && long >= 1 && long <= 180) {
            prefs.setInt(LONGBREAK, long);
            setState(() {
              txtLong.text = long.toString();
            });
          }
        }
        break;
    }
  }

}