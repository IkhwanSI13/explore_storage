import '../commons/const.dart';

class OrganizationModel {
  String id;
  String name;

  OrganizationModel({
    required this.id,
    required this.name,
  });

  // Convert  into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      Constant.organizationId: id,
      Constant.organizationName: name,
    };
  }

  // Implement toString to make it easier to see information about
  // each student when using the print statement.
  @override
  String toString() {
    return 'Organization{${Constant.studentId}: $id, '
        '${Constant.studentName}: $name}';
  }
}
