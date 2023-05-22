import 'package:flutter/material.dart';
import 'brain.dart';
import 'alzheimer.dart';

class ChooseModel extends StatelessWidget {
  const ChooseModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose The Model'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BrainModel()),
                );
              },
              child: const Text('Brain'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AlzheimerModel()),
                );
              },
              child: const Text('Alzheimer'),
            ),
          ],
        ),
      ),
    );
  }
}
