import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_app/app.dart';

import 'test_helpers.dart';

void _useLargeScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1600, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  late FakeServer server;

  setUp(() => server = FakeServer());

  testWidgets('Список показывает загрузку, затем данные с сервера', (tester) async {
    _useLargeScreen(tester);
    server.delay = const Duration(milliseconds: 50);

    await tester.pumpWidget(
      LibraryApp(repositories: makeRepositories(server), initialLocation: '/books'),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 5));
    await tester.pump(const Duration(milliseconds: 5));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Идиот'), findsWidgets);
  });

  testWidgets('Недоступный сервер показывает ошибку, кнопка повтора загружает данные', (tester) async {
    _useLargeScreen(tester);
    server.down = true;

    await tester.pumpWidget(
      LibraryApp(repositories: makeRepositories(server), initialLocation: '/books'),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Не удалось загрузить список'), findsOneWidget);
    expect(find.text('Повторить'), findsOneWidget);

    server.down = false;
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();

    expect(find.text('Повторить'), findsNothing);
    expect(find.text('Идиот'), findsWidgets);
  });

  testWidgets('Пустой результат поиска показывает сообщение, а не ошибку', (tester) async {
    _useLargeScreen(tester);

    await tester.pumpWidget(
      LibraryApp(
        repositories: makeRepositories(server),
        initialLocation: '/books?search=zzzzzz',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Книги не найдены'), findsOneWidget);
    expect(find.text('Повторить'), findsNothing);
  });

  testWidgets('Пустая форма книги показывает ошибки у обязательных полей', (tester) async {
    _useLargeScreen(tester);

    await tester.pumpWidget(
      LibraryApp(
        repositories: makeRepositories(server),
        initialLocation: '/books/new',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Новая книга'), findsOneWidget);

    await tester.ensureVisible(find.text('Сохранить'));
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    expect(find.text('Обязательное поле'), findsWidgets);
    expect(find.text('Выберите издательство'), findsOneWidget);
    expect(find.text('Выберите хотя бы одного автора'), findsOneWidget);
    expect(find.text('Выберите хотя бы один жанр'), findsOneWidget);
  });

  testWidgets('Ошибка 422 показывается под полем формы', (tester) async {
    _useLargeScreen(tester);

    await tester.pumpWidget(
      LibraryApp(
        repositories: makeRepositories(server),
        initialLocation: '/genres/new',
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Название *'), 'Роман');
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    expect(find.text('Такой жанр уже существует'), findsOneWidget);
    expect(server.calls('POST', '/genres'), hasLength(1));
  });

  testWidgets('Удаление издательства с книгами отклоняется с указанием числа книг', (tester) async {
    _useLargeScreen(tester);

    await tester.pumpWidget(
      LibraryApp(
        repositories: makeRepositories(server),
        initialLocation: '/publishers',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Азбука'), findsWidgets);

    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Удалить'));
    await tester.pumpAndSettle();

    expect(find.text('Действие невозможно'), findsOneWidget);
    expect(find.textContaining('у него есть книги'), findsOneWidget);
    expect(server.calls('DELETE', '/publishers/1'), isEmpty);
  });
}
