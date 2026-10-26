import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:library_app/app_repositories.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/core/auth_session.dart';
import 'package:library_app/models/json_helpers.dart';

class FakeServer implements HttpClientAdapter {
  FakeServer() {
    reset();
  }

  final List<RequestOptions> requests = [];
  bool down = false;
  bool malformed = false;
  Duration delay = Duration.zero;

  late Map<String, List<Map<String, dynamic>>> data;
  int _nextId = 100;
  int _issued = 0;
  String? _validToken;

  void reset() {
    data = {
      'genres': [
        {'id': 1, 'name': 'Роман', 'description': 'Крупная форма', 'deletedAt': null},
        {'id': 2, 'name': 'Фантастика', 'description': '', 'deletedAt': null},
      ],
      'publishers': [
        {'id': 1, 'name': 'Азбука', 'city': 'Санкт-Петербург', 'foundedYear': 1995, 'deletedAt': null},
        {'id': 2, 'name': 'Эксмо', 'city': 'Москва', 'foundedYear': 1991, 'deletedAt': null},
        {'id': 3, 'name': 'Питер', 'city': 'Санкт-Петербург', 'foundedYear': 1991, 'deletedAt': null},
      ],
      'authors': [
        {'id': 1, 'fullName': 'Достоевский Ф. М.', 'birthYear': 1821, 'country': 'Россия', 'deletedAt': null},
        {'id': 2, 'fullName': 'Оруэлл Дж.', 'birthYear': 1903, 'country': 'Великобритания', 'deletedAt': null},
      ],
      'books': [
        _book(1, 'Идиот', '978-5-389-07773-7', 1869, 1, [1], [1], 2, 2),
        _book(2, 'Преступление и наказание', '978-5-389-06003-6', 1866, 1, [1], [1], 5, 5),
        _book(3, '1984', '978-5-17-080115-5', 1949, 2, [2], [2], 5, 0),
        _book(4, 'Скотный двор', '978-5-17-097584-1', 1945, 2, [2], [2], 3, 3),
      ],
      'readers': [
        {
          'id': 1,
          'fullName': 'Смирнов П. А.',
          'email': 'smirnov@example.com',
          'phone': '+7 900 100-10-01',
          'card': {
            'id': 1,
            'number': 'RC-000001',
            'issuedAt': '2026-01-15T00:00:00.000Z',
            'expiresAt': '2027-01-15T00:00:00.000Z',
          },
          'deletedAt': null,
        },
        {
          'id': 2,
          'fullName': 'Кузнецова М. И.',
          'email': 'kuznetsova@example.com',
          'phone': '',
          'card': null,
          'deletedAt': null,
        },
      ],
      'loans': [
        {
          'id': 1,
          'reader': {'id': 1, 'fullName': 'Смирнов П. А.'},
          'book': {'id': 3, 'title': '1984'},
          'issuedAt': '2026-10-01T10:00:00.000Z',
          'dueAt': '2026-10-15T10:00:00.000Z',
          'returnedAt': null,
          'status': 'overdue',
          'deletedAt': null,
        },
      ],
    };
  }

  Map<String, dynamic> _book(
    int id,
    String title,
    String isbn,
    int year,
    int publisherId,
    List<int> authorIds,
    List<int> genreIds,
    int total,
    int available,
  ) {
    return {
      'id': id,
      'title': title,
      'isbn': isbn,
      'year': year,
      'pages': 300,
      'publisher': {'id': publisherId, 'name': 'Издательство $publisherId'},
      'authors': [for (final a in authorIds) {'id': a, 'fullName': 'Автор $a'}],
      'genres': [for (final g in genreIds) {'id': g, 'name': 'Жанр $g'}],
      'copiesTotal': total,
      'copiesAvailable': available,
      'deletedAt': null,
    };
  }

  void revokeToken() {
    _validToken = null;
  }

  int get loginCount => requests.where((r) => r.uri.path.endsWith('/auth/login')).length;

  Iterable<RequestOptions> calls(String method, String path) =>
      requests.where((r) => r.method == method && r.uri.path == '/api$path');

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);

    if (delay > Duration.zero) {
      final cancelled = cancelFuture?.then((_) => true) ?? Completer<bool>().future;
      final finished = Future<bool>.delayed(delay, () => false);
      if (await Future.any([cancelled, finished])) {
        throw DioException.requestCancelled(requestOptions: options, reason: 'cancel');
      }
    }

    if (down) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'Connection refused',
      );
    }
    return _route(options);
  }

  @override
  void close({bool force = false}) {}

  ResponseBody _json(int status, Object? body) {
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json; charset=utf-8'],
      },
    );
  }

  ResponseBody _fail(int status, String message) =>
      _json(status, {'message': message});

  ResponseBody _route(RequestOptions options) {
    final method = options.method.toUpperCase();
    final query = options.uri.queryParameters;
    final path = options.uri.path.replaceFirst('/api', '');
    final body = options.data is Map
        ? Map<String, dynamic>.from(options.data as Map)
        : <String, dynamic>{};

    if (query.containsKey('__fail')) {
      return _fail(int.parse(query['__fail']!), 'Ошибка вызвана намеренно');
    }

    if (path == '/auth/login' && method == 'POST') {
      _validToken = 'token-${++_issued}';
      return _json(200, {'accessToken': _validToken, 'expiresIn': 900});
    }

    final parts = path.split('/').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty || !data.containsKey(parts[0])) {
      return _fail(404, 'Адрес не обслуживается');
    }
    final collection = parts[0];
    final rows = data[collection]!;

    if (method != 'GET' && options.headers['Authorization'] != 'Bearer $_validToken') {
      return _fail(401, 'Требуется аутентификация');
    }

    if (method == 'GET' && parts.length == 1) {
      if (malformed) return _json(200, {'oops': 1});
      return _json(200, _list(collection, rows, query));
    }

    if (method == 'GET' && parts.length == 2) {
      final row = _find(rows, int.parse(parts[1]));
      return row == null ? _fail(404, 'Объект не найден') : _json(200, row);
    }

    if (method == 'POST' && collection == 'loans' && parts.length == 1) {
      return _issueLoan(body);
    }

    if (method == 'POST' && parts.length == 2 && parts[1] == 'bulk-delete') {
      final ids = (body['ids'] as List).cast<int>();
      var deleted = 0;
      for (final row in rows) {
        if (ids.contains(row['id']) && row['deletedAt'] == null) {
          row['deletedAt'] = DateTime.now().toIso8601String();
          deleted++;
        }
      }
      return _json(200, {'deleted': deleted});
    }

    if (method == 'POST' && parts.length == 3) {
      final row = _find(rows, int.parse(parts[1]));
      if (row == null) return _fail(404, 'Объект не найден');
      if (parts[2] == 'restore') row['deletedAt'] = null;
      if (parts[2] == 'return') row['returnedAt'] = DateTime.now().toIso8601String();
      return _json(200, row);
    }

    if (method == 'POST' && parts.length == 1) {
      final errors = _validate(collection, body, null);
      if (errors.isNotEmpty) {
        return _json(422, {'message': 'Ошибка валидации', 'errors': errors});
      }
      final row = {...body, 'id': _nextId++, 'deletedAt': null};
      rows.add(row);
      return _json(201, row);
    }

    if (method == 'PUT' && parts.length == 2) {
      final id = int.parse(parts[1]);
      final row = _find(rows, id);
      if (row == null) return _fail(404, 'Объект не найден');
      final errors = _validate(collection, body, id);
      if (errors.isNotEmpty) {
        return _json(422, {'message': 'Ошибка валидации', 'errors': errors});
      }
      row.addAll(body);
      if (collection == 'books') {
        row
          ..remove('publisher')
          ..remove('authors')
          ..remove('genres');
      }
      return _json(200, row);
    }

    if (method == 'DELETE' && parts.length == 2) {
      final id = int.parse(parts[1]);
      final row = _find(rows, id);
      if (row == null) return _fail(404, 'Объект не найден');
      if (query['hard'] == 'true') {
        rows.remove(row);
      } else {
        row['deletedAt'] = DateTime.now().toIso8601String();
      }
      return _json(204, null);
    }

    return _fail(404, 'Адрес не обслуживается');
  }

  int _bounded(int value, int low, int high) =>
      value < low ? low : (value > high ? high : value);

  Map<String, dynamic>? _find(List<Map<String, dynamic>> rows, int id) {
    for (final row in rows) {
      if (row['id'] == id) return row;
    }
    return null;
  }

  ResponseBody _issueLoan(Map<String, dynamic> body) {
    final book = _find(data['books']!, jsonInt(body['bookId']));
    final reader = _find(data['readers']!, jsonInt(body['readerId']));
    if (book == null || reader == null) {
      return _json(422, {
        'message': 'Ошибка валидации',
        'errors': {
          if (reader == null) 'readerId': 'Читатель не найден',
          if (book == null) 'bookId': 'Книга не найдена',
        },
      });
    }
    if (jsonInt(book['copiesAvailable']) < 1) {
      return _fail(409, 'Нет свободных экземпляров этой книги');
    }
    book['copiesAvailable'] = jsonInt(book['copiesAvailable']) - 1;
    final loan = {
      'id': _nextId++,
      'reader': {'id': reader['id'], 'fullName': reader['fullName']},
      'book': {'id': book['id'], 'title': book['title']},
      'issuedAt': DateTime.now().toIso8601String(),
      'dueAt': DateTime.now().add(const Duration(days: 14)).toIso8601String(),
      'returnedAt': null,
      'status': 'active',
      'deletedAt': null,
    };
    data['loans']!.add(loan);
    return _json(201, loan);
  }

  Map<String, String> _validate(String collection, Map<String, dynamic> body, int? id) {
    if (collection == 'books') {
      final duplicate = data['books']!.any(
        (b) => b['isbn'] == body['isbn'] && b['id'] != id && b['deletedAt'] == null,
      );
      if (duplicate) return {'isbn': 'Книга с таким ISBN уже существует'};
    }
    if (collection == 'genres') {
      final name = '${body['name']}'.toLowerCase();
      final duplicate = data['genres']!.any(
        (g) => '${g['name']}'.toLowerCase() == name && g['id'] != id && g['deletedAt'] == null,
      );
      if (duplicate) return {'name': 'Такой жанр уже существует'};
    }
    return const {};
  }

  Map<String, dynamic> _list(
    String collection,
    List<Map<String, dynamic>> source,
    Map<String, String> query,
  ) {
    var rows = source.where((r) => query['includeDeleted'] == 'true' || r['deletedAt'] == null).toList();

    final needle = (query['search'] ?? '').toLowerCase();
    if (needle.isNotEmpty) {
      rows = rows
          .where((r) => r.values.whereType<String>().join(' ').toLowerCase().contains(needle))
          .toList();
    }

    if (collection == 'books') {
      int? number(String key) => int.tryParse(query[key] ?? '');
      final genreId = number('genreId');
      final publisherId = number('publisherId');
      final authorId = number('authorId');
      final from = number('yearFrom');
      final to = number('yearTo');
      rows = rows.where((b) {
        if (genreId != null && !jsonRefIds(b['genres']).contains(genreId)) return false;
        if (authorId != null && !jsonRefIds(b['authors']).contains(authorId)) return false;
        if (publisherId != null && jsonRefId(b['publisher']) != publisherId) return false;
        if (from != null && jsonInt(b['year']) < from) return false;
        if (to != null && jsonInt(b['year']) > to) return false;
        if (query['available'] == 'true' && jsonInt(b['copiesAvailable']) < 1) return false;
        return true;
      }).toList();
    }

    if (collection == 'loans' && (query['status'] ?? '').isNotEmpty) {
      rows = rows.where((l) => l['status'] == query['status']).toList();
    }

    final sort = (query['sort'] ?? '').split(',');
    if (sort.first.isNotEmpty) {
      final direction = sort.length > 1 && sort[1] == 'desc' ? -1 : 1;
      rows.sort((a, b) {
        final left = a[sort.first];
        final right = b[sort.first];
        if (left is num && right is num) return left.compareTo(right) * direction;
        return '$left'.toLowerCase().compareTo('$right'.toLowerCase()) * direction;
      });
    }

    final size = _bounded(int.tryParse(query['size'] ?? '') ?? 10, 1, 100);
    final page = _bounded(int.tryParse(query['page'] ?? '') ?? 1, 1, 1000000);
    final total = rows.length;
    final from = (page - 1) * size;
    final end = from + size > total ? total : from + size;
    final items = from >= total ? <Map<String, dynamic>>[] : rows.sublist(from, end);

    return {
      'items': items,
      'page': page,
      'size': size,
      'total': total,
      'totalPages': total == 0 ? 1 : (total / size).ceil(),
    };
  }
}

AppRepositories makeRepositories(
  FakeServer server, {
  Map<String, String> debugFlags = const {},
}) {
  final session = AuthSession(
    username: 'admin',
    password: 'admin123',
    client: buildLoginDio(adapter: server),
  );
  final dio = buildDio(
    session: session,
    adapter: server,
    retryDelays: const [Duration.zero, Duration.zero],
    debugFlags: debugFlags,
  );
  return AppRepositories(dio: dio);
}
