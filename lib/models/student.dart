class Student {
  final String userID;
  final String firstName;
  final String lastName;
  final String email;
  final String nic;
  final String phoneNum;
  final String dateOfBirth;
  final String batch;
  final String studentClass;
  final String payment;
  final String date;
  final String deviceID;

  Student({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.nic,
    required this.phoneNum,
    required this.date,
    required this.dateOfBirth,
    required this.batch,
    required this.studentClass,
    required this.payment,
    required this.deviceID,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      userID: json['UserID'].toString(),
      firstName: json['FirstName'].toString(),
      lastName: json['LastName'].toString(),
      email: json['Email'].toString(),
      nic: json['NIC'].toString(),
      phoneNum: json['PhoneNumber'].toString(),
      dateOfBirth: json['DateOfBirth'].toString(),
      batch: json['Batch'].toString(),
      studentClass: json['Student_Class'].toString(),
      payment: json['Payment'].toString(),
      date: json['Registed_Date'],
      deviceID: json['Device_ID'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'NIC': nic,
      'PhoneNumber': phoneNum,
      'DateOfBirth': dateOfBirth,
      'Batch': batch,
      'Student_Class': studentClass,
      'Payment': payment,
      'Device_ID': deviceID,
      'Registed_Date': DateTime.now().toString(),
    };
  }
}
