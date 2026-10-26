import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/unsaved_changes.dart';
import 'confirm_dialog.dart';

class LibraryScaffold extends StatelessWidget {
  const LibraryScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showBack = false,
    this.backPath = '/books',
    this.unsaved,
  });

  final String title;
  final Widget body;
  final bool showBack;
  final String backPath;
  final UnsavedChanges? unsaved;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 900;
    return Scaffold(
      appBar: AppBar(
        leading: showBack
            ? BackButton(
                onPressed: () => guardedNavigate(context, unsaved, () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(backPath);
                  }
                }),
              )
            : null,
        title: Text(title),
        actions: [
          for (final item in _items)
            _NavButton(
              icon: item.icon,
              label: item.label,
              onTap: () => guardedNavigate(context, unsaved, () => context.go(item.path)),
              narrow: narrow,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: body,
    );
  }
}

typedef _NavItem = ({IconData icon, String label, String path});

const List<_NavItem> _items = [
  (icon: Icons.menu_book, label: 'Книги', path: '/books'),
  (icon: Icons.people, label: 'Авторы', path: '/authors'),
  (icon: Icons.category, label: 'Жанры', path: '/genres'),
  (icon: Icons.apartment, label: 'Издательства', path: '/publishers'),
  (icon: Icons.badge, label: 'Читатели', path: '/readers'),
  (icon: Icons.assignment, label: 'Выдачи', path: '/loans'),
];

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.narrow,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    if (narrow) {
      return IconButton(tooltip: label, icon: Icon(icon), onPressed: onTap);
    }
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
