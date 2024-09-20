import 'package:flutter/material.dart';
import 'package:notepad/widgets/notelistscreen.dart';
import 'package:notepad/widgets/themeprovider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  themeProvider.loadTheme(); // Load theme setting

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: NotepadApp(),
    ),
  );
}

class NotepadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Notepad App',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: NoteListScreen(),
    );
  }
}
