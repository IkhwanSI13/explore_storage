import 'package:explore_storage/repository/local/sqflite.dart';
import 'package:flutter/material.dart';

import '../models/student_model.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final keyFormStudent = GlobalKey<FormState>();

  TextEditingController controllerId = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDepartment = TextEditingController();
  TextEditingController controllerSks = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();

  List<StudentModel> students = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      students = await MySQFLite.instance.getStudents();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore SQFLite"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 36, left: 24, bottom: 4),
            child: const Text(
              "Input Student",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Form(
            key: keyFormStudent,
            child: Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  TextFormField(
                    controller: controllerId,
                    decoration: const InputDecoration(hintText: "ID"),
                    validator: (value) => _onValidateText(value),
                  ),
                  TextFormField(
                    controller: controllerName,
                    decoration: const InputDecoration(hintText: "Name"),
                    validator: (value) => _onValidateText(value),
                  ),
                  TextFormField(
                    controller: controllerDepartment,
                    decoration: const InputDecoration(hintText: "Department"),
                    validator: (value) => _onValidateText(value),
                  ),
                  TextFormField(
                    controller: controllerSks,
                    decoration: const InputDecoration(hintText: "SKS"),
                    validator: (value) => _onValidateText(value),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: controllerAddress,
                    decoration: const InputDecoration(hintText: "Address"),
                    validator: (value) => _onValidateText(value),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: ElevatedButton(
              onPressed: _onSaveStudent,
              child: const Text("Save"),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24, left: 24, bottom: 4),
            child: const Text("Student Data",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              itemBuilder: (BuildContext context, int index) {
                var value = students[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Id: ${value.id}"),
                      Text("Name: ${value.name}"),
                      Text("Department: ${value.department}"),
                      Text("SKS: ${value.sks}"),
                      Text("Address: ${value.address ?? "Empty"}"),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  String? _onValidateText(String? value) {
    if (value?.isEmpty ?? true) return 'Can\'t empty';
    return null;
  }

  _onSaveStudent() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (keyFormStudent.currentState?.validate() ?? false) {
      await MySQFLite.instance.insertStudent(StudentModel(
        id: controllerId.text,
        name: controllerName.text,
        department: controllerDepartment.text,
        sks: int.parse(controllerSks.text),
        address: controllerAddress.text,
      ));

      controllerId.text = "";
      controllerName.text = "";
      controllerDepartment.text = "";
      controllerSks.text = "";
      controllerAddress.text = "";

      students = await MySQFLite.instance.getStudents();
      setState(() {});
    }
  }
}
