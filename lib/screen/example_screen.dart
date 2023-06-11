import 'package:flutter/material.dart';

import '../repository/local/shared_preferences.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final MySharedPref _mySharedPref = MySharedPref();

  String _value = "Kosong";
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore SharedPreferences"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Simpan nilai",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                bottom: 8,
              ),
              child: TextField(
                controller: _inputController,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _mySharedPref.setValue(_inputController.value.text);
                _inputController.text = "";
              },
              child: const Text("Simpan"),
            ),
            Container(
              margin: const EdgeInsets.only(top: 32, bottom: 8),
              child: const Text(
                "Ambil nilai",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Center(
                child: Text("Nilai: $_value"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _mySharedPref.getValue().then((value) {
                    if (value != null) _value = value;
                  });
                });
              },
              child: const Text("Ambil"),
            )
          ],
        ),
      ),
    );
  }
}
