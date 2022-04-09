import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './components/navbar.dart';
import './components/settings_action.dart';
import '../utils/shared_pref.dart';
import './components/show_modal_bottom_sheet.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key, required this.title}) : super(key: key);

  final String title;
  
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<String> _saved = [];

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
        return _buildRow(_saved[i]);
      },
      itemCount: _saved.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        // color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [settingsAction(context)],
      ),
      body: _buildListItems(),
      bottomNavigationBar: navbar(1, context),
    );
  }
}
