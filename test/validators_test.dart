import 'package:flutter_test/flutter_test.dart';
import 'package:library_app/validation/validators.dart';

void main() {
  test('Обязательное поле: пустая строка и пробелы — ошибка', () {
    final check = notBlank();
    expect(check(''), isNotNull);
    expect(check('   '), isNotNull);
    expect(check('Текст'), isNull);
  });

  test('Длина: слишком короткое и слишком длинное значение', () {
    expect(minLength(3)('ab'), isNotNull);
    expect(minLength(3)('abc'), isNull);
    expect(maxLength(5)('123456'), isNotNull);
    expect(maxLength(5)('12345'), isNull);
  });

  test('Необязательные проверки пропускают пустое значение', () {
    expect(minLength(3)(''), isNull);
    expect(emailFormat()(''), isNull);
    expect(phoneFormat()(''), isNull);
    expect(integerInRange(1, 5)(''), isNull);
  });

  test('Целое число в диапазоне', () {
    final check = integerInRange(1450, 2026);
    expect(check('abc'), isNotNull);
    expect(check('1.5'), isNotNull);
    expect(check('1000'), isNotNull);
    expect(check('2100'), isNotNull);
    expect(check('2001'), isNull);
  });

  test('Положительное и неотрицательное число', () {
    expect(positiveInteger()('0'), isNotNull);
    expect(positiveInteger()('-3'), isNotNull);
    expect(positiveInteger(max: 10)('11'), isNotNull);
    expect(positiveInteger()('5'), isNull);
    expect(nonNegativeInteger()('-1'), isNotNull);
    expect(nonNegativeInteger()('0'), isNull);
  });

  test('Электронная почта', () {
    final check = emailFormat();
    expect(check('без-собаки.ru'), isNotNull);
    expect(check('a@b'), isNotNull);
    expect(check('a b@c.ru'), isNotNull);
    expect(check('name@example.com'), isNull);
  });

  test('ISBN из 10 или 13 цифр с дефисами', () {
    final check = isbnFormat();
    expect(check('12345'), isNotNull);
    expect(check('978-5-17-123456'), isNotNull);
    expect(check('978-5-17-123456-0'), isNull);
    expect(check('5-17-123456-0'), isNull);
  });

  test('Телефон', () {
    final check = phoneFormat();
    expect(check('abc'), isNotNull);
    expect(check('12345'), isNotNull);
    expect(check('+7 900 123-45-67'), isNull);
  });

  test('Имена: только буквы, пробел, точка и дефис', () {
    final check = namePattern();
    expect(check('Иван1'), isNotNull);
    expect(check('-Иван'), isNotNull);
    expect(check('Анна-Мария'), isNull);
    expect(check("O'Brien"), isNull);
    expect(check('Толстой Л. Н.'), isNull);
  });

  test('Дата в формате дд.мм.гггг и несуществующие даты', () {
    expect(parseRuDate('2025-01-01'), isNull);
    expect(parseRuDate('31.02.2025'), isNull);
    expect(parseRuDate('29.02.2024'), DateTime(2024, 2, 29));
    expect(parseRuDate('05.03.2025'), DateTime(2025, 3, 5));
    expect(formatRuDate(DateTime(2025, 3, 5)), '05.03.2025');
  });

  test('Составная проверка возвращает первую найденную ошибку', () {
    final validator = checks([notBlank(), minLength(3), maxLength(5)]);
    expect(validator('', {}), 'Обязательное поле');
    expect(validator('ab', {}), 'Не короче 3 символов');
    expect(validator('abcdef', {}), 'Не длиннее 5 символов');
    expect(validator('abcd', {}), isNull);
  });

  test('Выбор из списка обязателен', () {
    expect(mustChoose('Выберите')(null), 'Выберите');
    expect(mustChoose('Выберите')(3), isNull);
    expect(mustChooseAtLeastOne('Выберите')(<int>[]), 'Выберите');
    expect(mustChooseAtLeastOne('Выберите')([1]), isNull);
  });
}
