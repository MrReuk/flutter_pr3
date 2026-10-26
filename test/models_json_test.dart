import 'package:flutter_test/flutter_test.dart';
import 'package:library_app/models/author.dart';
import 'package:library_app/models/book.dart';
import 'package:library_app/models/genre.dart';
import 'package:library_app/models/loan.dart';
import 'package:library_app/models/publisher.dart';
import 'package:library_app/models/reader.dart';

void main() {
  test('Книга читается из развёрнутого ответа сервера', () {
    final book = Book.fromJson({
      'id': 1,
      'title': 'Война и мир',
      'isbn': '978-5-17-118366-4',
      'year': 1869,
      'pages': 1300,
      'publisher': {'id': 1, 'name': 'АСТ'},
      'authors': [
        {'id': 1, 'fullName': 'Толстой Л. Н.'},
      ],
      'genres': [
        {'id': 2, 'name': 'Роман'},
        {'id': 5, 'name': 'Классика'},
      ],
      'copiesTotal': 4,
      'copiesAvailable': 2,
      'deletedAt': '2026-01-02T03:04:00Z',
    });

    expect(book.publisherId, 1);
    expect(book.authorIds, [1]);
    expect(book.genreIds, [2, 5]);
    expect(book.copiesAvailable, 2);
    expect(book.isDeleted, isTrue);
  });

  test('Для записи книга превращается в плоское представление с идентификаторами', () {
    const book = Book(
      id: 7,
      title: 'Тест',
      isbn: '978-5-00-000001-0',
      year: 2020,
      pages: 10,
      publisherId: 3,
      authorIds: [1, 2],
      genreIds: [4],
      copiesTotal: 5,
      copiesAvailable: 1,
    );

    expect(book.toJson(), {
      'title': 'Тест',
      'isbn': '978-5-00-000001-0',
      'year': 2020,
      'pages': 10,
      'publisherId': 3,
      'authorIds': [1, 2],
      'genreIds': [4],
      'copiesTotal': 5,
    });
  });

  test('Читатель без билета и с билетом', () {
    final without = Reader.fromJson({
      'id': 1,
      'fullName': 'Смирнов П. А.',
      'email': 'smirnov@example.com',
      'card': null,
    });
    expect(without.card, isNull);
    expect(without.phone, '');

    final withCard = Reader.fromJson({
      'id': 2,
      'fullName': 'Кузнецова М. И.',
      'email': 'k@example.com',
      'card': {
        'id': 4,
        'number': 'RC-000004',
        'issuedAt': '2026-01-15T00:00:00Z',
        'expiresAt': '2027-01-15T00:00:00Z',
      },
    });
    expect(withCard.card?.number, 'RC-000004');
    expect(withCard.card?.isExpiredAt(DateTime.utc(2028)), isTrue);
    expect(withCard.card?.isExpiredAt(DateTime.utc(2026, 6)), isFalse);
    expect(withCard.toJson().containsKey('card'), isFalse);
  });

  test('Выдача читается вместе с названием книги и состоянием', () {
    final loan = Loan.fromJson({
      'id': 3,
      'reader': {'id': 1, 'fullName': 'Смирнов П. А.'},
      'book': {'id': 9, 'title': '1984'},
      'issuedAt': '2026-08-01T10:00:00Z',
      'dueAt': '2026-08-15T10:00:00Z',
      'returnedAt': null,
      'status': 'overdue',
    });

    expect(loan.readerName, 'Смирнов П. А.');
    expect(loan.bookTitle, '1984');
    expect(loan.status, LoanStatus.overdue);
    expect(loan.isClosed, isFalse);
    expect(LoanStatus.parse('returned'), LoanStatus.returned);
    expect(LoanStatus.parse('что-то другое'), LoanStatus.active);
  });

  test('Чтение терпимо к пропущенным и пустым полям', () {
    final book = Book.fromJson({'id': 5});
    expect(book.title, '');
    expect(book.year, 0);
    expect(book.publisherId, 0);
    expect(book.authorIds, isEmpty);
    expect(book.deletedAt, isNull);

    final nulls = Book.fromJson({
      'id': null,
      'title': null,
      'authors': null,
      'genres': 'не список',
      'deletedAt': 'не дата',
    });
    expect(nulls.id, 0);
    expect(nulls.authorIds, isEmpty);
    expect(nulls.genreIds, isEmpty);
    expect(nulls.deletedAt, isNull);

    expect(Author.fromJson(const {}).fullName, '');
    expect(Author.fromJson(const {}).birthYear, isNull);
    expect(Genre.fromJson(const {'id': '7'}).id, 7);
    expect(Publisher.fromJson(const {'foundedYear': 1999.0}).foundedYear, 1999);
  });
}
