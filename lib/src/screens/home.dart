import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './components/navbar.dart';
import './components/settings_action.dart';
import '../../src/data/stops.dart';
import '../utils/shared_pref.dart';
import './components/show_modal_bottom_sheet.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget _title = const Text('Контроль.Гродно!');
  List<String> _filteredStops = stops;
  // final _saved = <String>{};
  List<String> _saved = [];

  Icon _searchIcon = const Icon(Icons.search);
  final TextEditingController _filter = TextEditingController();
  String _inputText = '';

  _HomeState() {
    // TODO событие изменения содержимого TextField можно отловить каким-то методом контролера без обработчика событий
    _filter.addListener(() {
      _inputText = _filter.text;

      setState(() {
        // stops which contain input text but not in brackets
        _filteredStops = stops
            .where((stop) => stop
                .replaceAll(RegExp(r'\(.*\)'), '')
                .toLowerCase()
                .contains(_inputText.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void initState() {
    _setSaved();
    super.initState();
  }

  void _setSaved() async {
    List<String>? items;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    items = prefs.getStringList('saved');
    setState(() {
      _saved = items ?? [];
    });
  }

  Widget _buildListItems() {
    Widget _buildRow(String title) {
      final alreadySaved = _saved.contains(title);

      final String titleStop;
      final String titleDirection;

      bool hasDirection = title.contains(' (');

      if (hasDirection) {
        titleStop = title.split(' (')[0];
        titleDirection = title.split(' (')[1].substring(0, (title.split(' (')[1]).length - 1);
      }
      else {
        titleStop = title;
        titleDirection = '';
      }

      if (hasDirection) {
        return ListTile(
          title: Text(
            titleStop,
            style: TextStyle(color: Colors.black.withOpacity(0.85)),
          ),
          subtitle: Text(
            titleDirection,
            style: TextStyle(color: Colors.grey.withOpacity(0.85), fontSize: 14),
          ),
          // contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          trailing: IconButton(
            icon: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onPressed: () => setState(() {
              alreadySaved ? _saved.remove(title) : _saved.add(title);
              updateSaved(_saved);
            }),
          ),
          onTap: () => modalBottomSheet(context, titleStop, titleDirection),
        );
      }
      else {
        return ListTile(
          title: Text(
            title,
            style: TextStyle(color: Colors.black.withOpacity(0.85)),
          ),
          // contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          trailing: IconButton(
            icon: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onPressed: () => setState(() {
              alreadySaved ? _saved.remove(title) : _saved.add(title);
              updateSaved(_saved);
            }),
          ),
          onTap: () => modalBottomSheet(context, titleStop, titleDirection),
        );
      }
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      itemBuilder: (context, i) {
        return _buildRow(_filteredStops[i]);
      },
      itemCount: _filteredStops.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(
          // color: Colors.black,
          ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = const Icon(Icons.close);
        _title = TextField(
          controller: _filter,
          showCursor: true,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            // prefixIcon: Icon(Icons.search),
            hintText: 'Поиск остановок...',
            hintStyle:
                TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18),
            border: InputBorder.none,
          ),
        );
      } else {
        _searchIcon = const Icon(Icons.search);
        _title = const Text('Контроль.Гродно!');
        _filter.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title,
        actions: [
          IconButton(
            icon: _searchIcon,
            onPressed: () => _searchPressed(),
            tooltip: 'Поиск',
          ),
          settingsAction(context),
        ],
      ),
      body: _buildListItems(),
      bottomNavigationBar: navbar(0, context),
    );
  }
}
