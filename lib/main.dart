import 'package:flutter/material.dart';
import 'music_box.dart';
import 'account_page.dart'; // Import the Account Page

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

  static final List<Widget> _pages = <Widget>[
    const MusicBoxPage(),
    const Center(
        child: Text('Other Section')), // Placeholder for other sections
    const AccountPage(), // Account Page Added
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
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
