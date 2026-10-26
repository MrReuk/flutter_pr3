import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/publisher.dart';
import '../repositories/entity_repository.dart';
import '../validation/validators.dart';
import '../widgets/entity_form.dart';
import 'entity_form_screen.dart';

class PublisherFormScreen extends StatelessWidget {
  const PublisherFormScreen({super.key, this.publisherId});

  final int? publisherId;

  @override
  Widget build(BuildContext context) {
    final publishers = context.read<PublisherRepository>();
    final id = publisherId;

    return EntityFormScreen<Publisher>(
      title: id == null ? 'Новое издательство' : 'Редактирование издательства',
      backPath: '/publishers',
      notFoundMessage: 'Издательство не найдено',
      savedMessage: id == null ? 'Издательство добавлено' : 'Изменения сохранены',
      loadItem: id == null ? null : () => publishers.findById(id),
      initialValues: (publisher) {
        final year = publisher?.foundedYear;
        return {
          'name': publisher?.name ?? '',
          'city': publisher?.city ?? '',
          'foundedYear': year == null ? '' : '$year',
        };
      },
      fields: (publisher) => [
        FieldSpec.text(
          key: 'name',
          label: 'Название',
          required: true,
          maxLength: 80,
          validator: checks([notBlank(), minLength(2), maxLength(80)]),
        ),
        FieldSpec.text(
          key: 'city',
          label: 'Город',
          maxLength: 60,
          validator: checks([maxLength(60), namePattern()]),
        ),
        FieldSpec.text(
          key: 'foundedYear',
          label: 'Год основания',
          keyboardType: TextInputType.number,
          formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9-]'))],
          validator: checks([integerInRange(1400, DateTime.now().year)]),
        ),
      ],
      save: (values, existing) async {
        final year = (values['foundedYear'] as String).trim();
        final draft = Publisher(
          id: existing?.id ?? 0,
          name: (values['name'] as String).trim(),
          city: (values['city'] as String).trim(),
          foundedYear: year.isEmpty ? null : int.parse(year),
          deletedAt: existing?.deletedAt,
        );
        if (existing == null) {
          await publishers.create(draft);
        } else {
          await publishers.update(draft);
        }
      },
    );
  }
}
