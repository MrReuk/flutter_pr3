import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/author.dart';
import '../repositories/author_repository.dart';
import '../validation/validators.dart';
import '../widgets/entity_form.dart';
import 'entity_form_screen.dart';

class AuthorFormScreen extends StatelessWidget {
  const AuthorFormScreen({super.key, this.authorId});

  final int? authorId;

  @override
  Widget build(BuildContext context) {
    final authors = context.read<AuthorRepository>();
    final id = authorId;

    return EntityFormScreen<Author>(
      title: id == null ? 'Новый автор' : 'Редактирование автора',
      backPath: '/authors',
      notFoundMessage: 'Автор не найден',
      savedMessage: id == null ? 'Автор добавлен' : 'Изменения сохранены',
      loadItem: id == null ? null : () => authors.findById(id),
      initialValues: (author) {
        final year = author?.birthYear;
        return {
          'fullName': author?.fullName ?? '',
          'country': author?.country ?? '',
          'birthYear': year == null ? '' : '$year',
        };
      },
      fields: (author) => [
        FieldSpec.text(
          key: 'fullName',
          label: 'ФИО',
          required: true,
          hint: 'Толстой Л. Н.',
          maxLength: 100,
          validator: checks([notBlank(), minLength(2), maxLength(100), namePattern()]),
        ),
        FieldSpec.text(
          key: 'country',
          label: 'Страна',
          maxLength: 60,
          validator: checks([maxLength(60), namePattern()]),
        ),
        FieldSpec.text(
          key: 'birthYear',
          label: 'Год рождения',
          keyboardType: TextInputType.number,
          formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9-]'))],
          validator: checks([integerInRange(1, DateTime.now().year)]),
        ),
      ],
      save: (values, existing) async {
        final year = (values['birthYear'] as String).trim();
        final draft = Author(
          id: existing?.id ?? 0,
          fullName: (values['fullName'] as String).trim(),
          country: (values['country'] as String).trim(),
          birthYear: year.isEmpty ? null : int.parse(year),
          deletedAt: existing?.deletedAt,
        );
        if (existing == null) {
          await authors.create(draft);
        } else {
          await authors.update(draft);
        }
      },
    );
  }
}
