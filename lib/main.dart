// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      theme: ThemeData(
          brightness: Brightness.light, primaryColor: Colors.blueGrey[900]),
      title: 'StartUp Name Generator',
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  //final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (BuildContext context, int i) {
          if (i.isOdd)
            return Divider(
              color: Colors.white,
            );

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : Colors.white,
      ),
      onTap: () {
        if (alreadySaved)
          _saved.remove(pair);
        else
          _saved.add(pair);
      },
      title: Text(
        pair.asPascalCase,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
        title: Text('StartUp Name Generator'),
      ),
      body: _buildSuggestions(),
      backgroundColor: Colors.black,
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
        return ListTile(
            title: Text(
          pair.asPascalCase,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ));
      });
      final List<Widget> divided = ListTile.divideTiles(
        color: Colors.white,
        tiles: tiles,
        context: context,
      ).toList();
      return Scaffold(
        appBar: AppBar(
          title: Text("Saved Suggestions"),
        ),
        backgroundColor: Colors.black,
        body: ListView(children: divided),
      );
    }));
  }
}

class RandomWords extends StatefulWidget {
  RandomWordsState createState() => RandomWordsState();
}
