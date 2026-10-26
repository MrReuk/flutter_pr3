import 'package:dio/dio.dart';

import 'core/api_client.dart';
import 'core/auth_session.dart';
import 'core/config.dart';
import 'repositories/api_author_repository.dart';
import 'repositories/api_book_repository.dart';
import 'repositories/api_genre_repository.dart';
import 'repositories/api_loan_repository.dart';
import 'repositories/api_publisher_repository.dart';
import 'repositories/api_reader_repository.dart';

class AppRepositories {
  AppRepositories({required Dio dio}) {
    books = ApiBookRepository(dio: dio);
    authors = ApiAuthorRepository(dio: dio, books: books);
    genres = ApiGenreRepository(dio: dio, books: books);
    publishers = ApiPublisherRepository(dio: dio, books: books);
    readers = ApiReaderRepository(dio: dio);
    loans = ApiLoanRepository(dio: dio);
  }

  factory AppRepositories.connect({Map<String, String> debugFlags = const {}}) {
    final session = AuthSession(
      username: apiUser,
      password: apiPassword,
      client: buildLoginDio(),
    );
    return AppRepositories(
      dio: buildDio(session: session, debugFlags: debugFlags),
    );
  }

  late final ApiBookRepository books;
  late final ApiAuthorRepository authors;
  late final ApiGenreRepository genres;
  late final ApiPublisherRepository publishers;
  late final ApiReaderRepository readers;
  late final ApiLoanRepository loans;
}
