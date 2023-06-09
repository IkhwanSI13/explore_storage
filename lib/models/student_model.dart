import '../commons/const.dart';

class StudentModel {
  String id;
  String name;
  String department;
  int sks;
  String? address;

  StudentModel({
    required this.id,
    required this.name,
    required this.department,
    required this.sks,
    this.address,
  });

  // Convert  into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      Constant.studentId: id,
      Constant.studentName: name,
      Constant.studentDepartment: department,
      Constant.studentSKS: sks,
      Constant.studentAddress: address,
    };
  }

  // Implement toString to make it easier to see information about
  // each student when using the print statement.
  @override
  String toString() {
    return 'Student{${Constant.studentId}: $id, ${Constant.studentName}: $name, '
        '${Constant.studentDepartment}: $department, '
        '${Constant.studentSKS}: $sks, ${Constant.studentAddress}: $address}';
  }
}
