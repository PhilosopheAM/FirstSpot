import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  // 初始化Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // 启用Firebase调试模式
  FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: true,
  );
  
  // 启用Firestore调试日志
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  
  // 启用Analytics调试模式
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  
  // Run test function once at startup
  test();
  runApp(const MyApp());
}

void null_test(String? first, String? middle, String? last){
  String? name = first;
  name ??= middle;
  name ??= last;
  print(name);
}
void test() async{
  for (final value in getNumbers()){
    print(value);
  }
  
}
Iterable<int> getNumbers() sync*{
  yield 1;
  yield 2;
  yield 3;
}
Stream<String> StreamOfString(){
  return Stream.periodic(const Duration(seconds: 1), (index) => "Harry $index");
}

Future<int> MultiplyByTwo(int a){
  return Future.delayed(const Duration(seconds: 10), () => a * 2);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HolaPage(),
    );
  }
}

class HolaPage extends StatefulWidget {
  const HolaPage({super.key});

  @override
  State<HolaPage> createState() => _HolaPageState();
}

class _HolaPageState extends State<HolaPage> {
  // false 表示 Night（白底黑字），true 表示 Day（黑底白字）
  bool _isDay = false;

  @override
  Widget build(BuildContext context) {
    final bool showDayStyle = _isDay;
    final Color backgroundColor = showDayStyle ? Colors.black : Colors.white;
    final Color textColor = showDayStyle ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          Center(
            child: Text(
              'Hola!',
              style: TextStyle(
                fontSize: 48,
                color: textColor,
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isDay = true;
                    });
                  },
                  child: const Text('Day'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isDay = false;
                    });
                  },
                  child: const Text('Night'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
