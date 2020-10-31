import 'package:common_knowledge/models/RefBooks.dart';
import 'package:common_knowledge/models/User.dart';
import 'package:common_knowledge/services/database_service.dart';
import 'package:common_knowledge/ui/screens/home/home_screen.dart';
import 'package:common_knowledge/ui/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<String>(context);
    final DatabaseService _databaseService = DatabaseService(uid: user);
    return user != null
        ? MultiProvider(
            providers: [
              StreamProvider<User>(
                  create: (_) => _databaseService.getUserProfile()),
            ],
            child: HomeScreen(),
          )
        : WelcomeScreen();
  }
}
