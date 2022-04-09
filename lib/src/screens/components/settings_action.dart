import 'package:flutter/material.dart';

IconButton settingsAction(context) {
  return IconButton(
    icon: const Icon(Icons.settings),
    onPressed: () => Navigator.pushNamed(context, '/settings'),
    tooltip: 'Настройки',
  );
}