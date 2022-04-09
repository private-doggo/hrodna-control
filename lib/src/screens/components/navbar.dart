import 'package:flutter/material.dart';

BottomNavigationBar navbar(ind, context) {
  void navigator(index, context) {
    final String route;

    switch (index) {
      case 0:
        {
          route = '/';
          break;
        }
      case 1:
        {
          route = '/favourites';
          break;
        }
      default:
        {
          route = '/';
          break;
        }
    }

    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.location_pin),
        label: 'Остановки',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Избранное',
      ),
    ],
    currentIndex: ind,
    onTap: (index) => navigator(index, context),
    selectedItemColor: Colors.amber[800],
  );
}
