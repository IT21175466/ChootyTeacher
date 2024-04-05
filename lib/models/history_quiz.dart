class HistoryQuiz {
  final String studentID;
  final String quizName;
  final String marks;
  final String date;

  HistoryQuiz({
    required this.studentID,
    required this.quizName,
    required this.marks,
    required this.date,
  });

  factory HistoryQuiz.fromJson(Map<String, dynamic> json) {
    return HistoryQuiz(
      studentID: json['StudentID'].toString(),
      quizName: json['QuizName'].toString(),
      marks: json['Marks'].toString(),
      date: json['Date'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StudentID': studentID,
      'QuizName': quizName,
      'Marks': marks,
      'Date': date,
    };
  }
}
