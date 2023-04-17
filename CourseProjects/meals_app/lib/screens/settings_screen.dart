import 'package:flutter/material.dart';
import 'package:meals/widgets/main_drawer.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  final Function saveFilters;
  final Map<String, bool> currentFilters;

  SettingsScreen(this.saveFilters, this.currentFilters);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _glutenFree = false;
  var _vegetarian = false;
  var _vegan = false;
  var _lactoseFree = false;

  @override
  initState() {
    _glutenFree = widget.currentFilters['gluten'];
    _lactoseFree = widget.currentFilters['lactose'];
    _vegetarian = widget.currentFilters['vegeterian'];
    _vegan = widget.currentFilters['vegan'];
    super.initState();
  }

  SwitchListTile _buildSwitchListTile(
      String title, String subTitle, bool currentVal, Function updateVal) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      value: currentVal,
      onChanged: updateVal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
              onPressed: () => widget.saveFilters(
                    {
                      'gluten': _glutenFree,
                      'lactose': _lactoseFree,
                      'vegeterian': _vegetarian,
                      'vegan': _vegan,
                    },
                  ),
              icon: Icon(Icons.save))
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildSwitchListTile('Gluten-free',
                    'Only include gluten-free meals', _glutenFree, (val) {
                  setState(() {
                    _glutenFree = val;
                  });
                }),
                _buildSwitchListTile('Lactoce-free',
                    'Only include lactose-free meals', _lactoseFree, (val) {
                  setState(() {
                    _lactoseFree = val;
                  });
                }),
                _buildSwitchListTile(
                    'Vegetrian', 'Only include vegeterian meals', _vegetarian,
                    (val) {
                  setState(() {
                    _vegetarian = val;
                  });
                }),
                _buildSwitchListTile(
                    'Vegan', 'Only include vegan meals', _vegan, (val) {
                  setState(() {
                    _vegan = val;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
