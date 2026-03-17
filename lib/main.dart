import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/input_section.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TravelPlan());
}

class TravelPlan extends StatelessWidget {
  const TravelPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Plan',
      home: const InputScreen(title: 'TRAVEL PLAN'),
    );
  }
}