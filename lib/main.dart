import 'package:common_knowledge/services/auth_service.dart';
import 'package:common_knowledge/utilities/themes.dart';
import 'package:common_knowledge/shared/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(CommonKnowledgeApp());

class CommonKnowledgeApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        StreamProvider<String>(create: (_) => _authService.onAuthStateChanged),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Common Knowledge',
        theme: defaultTheme,
        home: Wrapper(),
      ),
    );
  }
}
