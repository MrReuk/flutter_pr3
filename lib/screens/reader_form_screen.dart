import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reader.dart';
import '../repositories/entity_repository.dart';
import '../validation/validators.dart';
import '../widgets/entity_form.dart';
import 'entity_form_screen.dart';

class ReaderFormScreen extends StatelessWidget {
  const ReaderFormScreen({super.key, this.readerId});

  final int? readerId;

  @override
  Widget build(BuildContext context) {
    final readers = context.read<ReaderRepository>();
    final id = readerId;

    return EntityFormScreen<Reader>(
      title: id == null ? 'Новый читатель' : 'Редактирование читателя',
      backPath: '/readers',
      notFoundMessage: 'Читатель не найден',
      savedMessage: id == null ? 'Читатель добавлен' : 'Изменения сохранены',
      loadItem: id == null ? null : () => readers.findById(id),
      initialValues: (reader) => {
        'fullName': reader?.fullName ?? '',
        'email': reader?.email ?? '',
        'phone': reader?.phone ?? '',
      },
      fields: (reader) => [
        FieldSpec.text(
          key: 'fullName',
          label: 'ФИО',
          required: true,
          hint: 'Смирнов П. А.',
          maxLength: 100,
          validator: checks([notBlank(), minLength(2), maxLength(100), namePattern()]),
        ),
        FieldSpec.text(
          key: 'email',
          label: 'Электронная почта',
          required: true,
          hint: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
          maxLength: 100,
          validator: checks([notBlank(), maxLength(100), emailFormat()]),
        ),
        FieldSpec.text(
          key: 'phone',
          label: 'Телефон',
          hint: '+7 900 123-45-67',
          keyboardType: TextInputType.phone,
          validator: checks([phoneFormat()]),
        ),
      ],
      save: (values, existing) async {
        final draft = Reader(
          id: existing?.id ?? 0,
          fullName: (values['fullName'] as String).trim(),
          email: (values['email'] as String).trim(),
          phone: (values['phone'] as String).trim(),
          card: existing?.card,
          deletedAt: existing?.deletedAt,
        );
        if (existing == null) {
          await readers.create(draft);
        } else {
          await readers.update(draft);
        }
      },
    );
  }
}
