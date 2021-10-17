import 'package:flutter/material.dart';
import 'package:tekko/screens/groupInformation/groupList/groupCreatedList.dart';
import 'package:tekko/screens/groupInformation/groupList/groupList.dart';

//group bottom naviagation
class GroupNavigation extends StatefulWidget {
  GroupNavigation({Key key}) : super(key: key);

  @override
  _GroupNavigationState createState() => _GroupNavigationState();
}

class _GroupNavigationState extends State<GroupNavigation> {
  int _seletedItem = 0;
  var _pages = [GroupList(), CreatedGroupList()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_seletedItem],),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
  backgroundColor: Colors.blueGrey,
  selectedItemColor: Colors.white,
  unselectedItemColor: Colors.white.withOpacity(.60),
  selectedFontSize: 14,
  unselectedFontSize: 14,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'My Group List',),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'My Created Group',),
        ],
        currentIndex: _seletedItem,
        onTap: (index){
          setState(() {
            _seletedItem = index;
          });
        },
      ),
    );
  }
}