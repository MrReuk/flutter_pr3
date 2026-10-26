import 'json_helpers.dart';

enum LoanStatus {
  active('Выдана'),
  overdue('Просрочена'),
  returned('Возвращена');

  const LoanStatus(this.label);

  final String label;

  static LoanStatus parse(Object? value) {
    return switch (value) {
      'returned' => LoanStatus.returned,
      'overdue' => LoanStatus.overdue,
      _ => LoanStatus.active,
    };
  }
}

class Loan {
  final int id;
  final int readerId;
  final String readerName;
  final int bookId;
  final String bookTitle;
  final DateTime? issuedAt;
  final DateTime? dueAt;
  final DateTime? returnedAt;
  final LoanStatus status;
  final DateTime? deletedAt;

  const Loan({
    required this.id,
    required this.readerId,
    required this.readerName,
    required this.bookId,
    required this.bookTitle,
    this.issuedAt,
    this.dueAt,
    this.returnedAt,
    this.status = LoanStatus.active,
    this.deletedAt,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    final reader = jsonMap(json['reader']);
    final book = jsonMap(json['book']);
    return Loan(
      id: jsonInt(json['id']),
      readerId: jsonInt(reader['id']),
      readerName: jsonString(reader['fullName']),
      bookId: jsonInt(book['id']),
      bookTitle: jsonString(book['title']),
      issuedAt: jsonDate(json['issuedAt']),
      dueAt: jsonDate(json['dueAt']),
      returnedAt: jsonDate(json['returnedAt']),
      status: LoanStatus.parse(json['status']),
      deletedAt: jsonDate(json['deletedAt']),
    );
  }

  bool get isDeleted => deletedAt != null;

  bool get isClosed => returnedAt != null;
}
