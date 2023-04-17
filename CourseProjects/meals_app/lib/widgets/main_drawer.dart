import 'package:flutter/material.dart';
import 'package:meals/screens/settings_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget _buildListTile(
      String title, IconData icon, String page, BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.of(context).pushReplacementNamed(page);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              'Cooking Up!',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _buildListTile('Meals', Icons.restaurant, '/', context),
          _buildListTile(
              'Settings', Icons.settings, SettingsScreen.routeName, context),
        ],
      ),
    );
  }
}
