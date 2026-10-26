import 'package:flutter/material.dart';

import '../models/publisher.dart';
import '../models/simple_query.dart';
import '../widgets/entity_table.dart';
import 'simple_list_screen.dart';

class PublisherListScreen extends StatelessWidget {
  const PublisherListScreen({super.key, required this.query});

  final SimpleQuery query;

  @override
  Widget build(BuildContext context) {
    return SimpleListScreen<Publisher>(
      query: query,
      config: SimpleListConfig<Publisher>(
        title: 'Издательства',
        path: '/publishers',
        searchLabel: 'Поиск по названию или городу',
        emptyMessage: 'Издательства не найдены. Измените поиск или фильтры.',
        addLabel: 'Добавить издательство',
        columns: (context) => [
          TableColumnSpec<Publisher>(
            label: 'Название',
            sortField: 'name',
            build: (p) => Text(p.name),
          ),
          TableColumnSpec<Publisher>(
            label: 'Город',
            sortField: 'city',
            build: (p) => Text(p.city.isEmpty ? '—' : p.city),
          ),
          TableColumnSpec<Publisher>(
            label: 'Год основания',
            sortField: 'foundedYear',
            numeric: true,
            build: (p) => Text(p.foundedYear == null ? '—' : '${p.foundedYear}'),
          ),
        ],
        idOf: (p) => p.id,
        isDeleted: (p) => p.isDeleted,
        nameOf: (p) => p.name,
        subtitleOf: (p) => [
          if (p.city.isNotEmpty) p.city,
          if (p.foundedYear != null) 'основано в ${p.foundedYear} г.',
        ].join(' · '),
      ),
    );
  }
}
