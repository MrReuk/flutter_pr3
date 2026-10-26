import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/author.dart';
import 'models/author_query.dart';
import 'models/book.dart';
import 'models/book_query.dart';
import 'models/genre.dart';
import 'models/publisher.dart';
import 'models/reader.dart';
import 'models/simple_query.dart';
import 'repositories/author_repository.dart';
import 'repositories/book_repository.dart';
import 'repositories/entity_repository.dart';
import 'screens/author_detail_screen.dart';
import 'screens/author_form_screen.dart';
import 'screens/author_list_screen.dart';
import 'screens/book_detail_screen.dart';
import 'screens/book_form_screen.dart';
import 'screens/book_list_screen.dart';
import 'screens/genre_detail_screen.dart';
import 'screens/genre_form_screen.dart';
import 'screens/genre_list_screen.dart';
import 'screens/loan_form_screen.dart';
import 'screens/loan_list_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/publisher_detail_screen.dart';
import 'screens/publisher_form_screen.dart';
import 'screens/publisher_list_screen.dart';
import 'screens/reader_detail_screen.dart';
import 'screens/reader_form_screen.dart';
import 'screens/reader_list_screen.dart';
import 'state/detail_notifier.dart';

int? _idFrom(GoRouterState state) => int.tryParse(state.pathParameters['id'] ?? '');

GoRoute _entityRoute<T>({
  required String path,
  required Widget Function(GoRouterState state) list,
  required Widget Function(int? id) form,
  required Widget detail,
  required Future<T?> Function(int id) Function(BuildContext context) finder,
}) {
  return GoRoute(
    path: '/$path',
    builder: (context, state) => list(state),
    routes: [
      GoRoute(
        path: 'new',
        builder: (context, state) => form(null),
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = _idFrom(state);
          if (id == null) return NotFoundScreen(location: state.uri.toString());
          return ChangeNotifierProvider<DetailNotifier<T>>(
            create: (context) {
              final find = finder(context);
              return DetailNotifier<T>(() => find(id))..load();
            },
            child: detail,
          );
        },
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final id = _idFrom(state);
              if (id == null) return NotFoundScreen(location: state.uri.toString());
              return form(id);
            },
          ),
        ],
      ),
    ],
  );
}

GoRouter buildRouter({String initialLocation = '/books'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/books',
      ),
      _entityRoute<Book>(
        path: 'books',
        list: (state) => BookListScreen(
          query: BookQuery.fromParams(state.uri.queryParameters),
        ),
        form: (id) => BookFormScreen(bookId: id),
        detail: const BookDetailScreen(),
        finder: (context) => context.read<BookRepository>().findById,
      ),
      _entityRoute<Author>(
        path: 'authors',
        list: (state) => AuthorListScreen(
          query: AuthorQuery.fromParams(state.uri.queryParameters),
        ),
        form: (id) => AuthorFormScreen(authorId: id),
        detail: const AuthorDetailScreen(),
        finder: (context) => context.read<AuthorRepository>().findById,
      ),
      _entityRoute<Genre>(
        path: 'genres',
        list: (state) => GenreListScreen(
          query: SimpleQuery.fromParams(
            state.uri.queryParameters,
            sortFields: kGenreSortFields,
            defaultSort: 'name',
          ),
        ),
        form: (id) => GenreFormScreen(genreId: id),
        detail: const GenreDetailScreen(),
        finder: (context) => context.read<GenreRepository>().findById,
      ),
      _entityRoute<Publisher>(
        path: 'publishers',
        list: (state) => PublisherListScreen(
          query: SimpleQuery.fromParams(
            state.uri.queryParameters,
            sortFields: kPublisherSortFields,
            defaultSort: 'name',
          ),
        ),
        form: (id) => PublisherFormScreen(publisherId: id),
        detail: const PublisherDetailScreen(),
        finder: (context) => context.read<PublisherRepository>().findById,
      ),
      _entityRoute<Reader>(
        path: 'readers',
        list: (state) => ReaderListScreen(
          query: SimpleQuery.fromParams(
            state.uri.queryParameters,
            sortFields: kReaderSortFields,
            defaultSort: 'fullName',
          ),
        ),
        form: (id) => ReaderFormScreen(readerId: id),
        detail: const ReaderDetailScreen(),
        finder: (context) => context.read<ReaderRepository>().findById,
      ),
      GoRoute(
        path: '/loans',
        builder: (context, state) => LoanListScreen(
          query: SimpleQuery.fromParams(
            state.uri.queryParameters,
            sortFields: kLoanSortFields,
            defaultSort: 'issuedAt',
          ),
        ),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const LoanFormScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => NotFoundScreen(location: state.uri.toString()),
  );
}
