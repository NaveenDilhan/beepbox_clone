import 'package:flutter/material.dart';
import 'music_box.dart';  // Import the separate music box page

void main() {
  runApp(const MusicBoxApp());
}

class MusicBoxApp extends StatefulWidget {
  const MusicBoxApp({super.key});

  @override
  _MusicBoxAppState createState() => _MusicBoxAppState();
}

class _MusicBoxAppState extends State<MusicBoxApp> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    MusicBoxPage(), // Music Box Page
    Center(child: Text('Other Section')), // Placeholder for other sections
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Sequencer',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Music App'),
          centerTitle: true,
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Music Box',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'Other',
            ),
          ],
        ),
      ),
    );
  }
}
