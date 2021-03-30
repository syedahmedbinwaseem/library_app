import 'package:flutter/material.dart';
import 'package:library_app/ui/screens/user/dashboard.dart';
import 'package:library_app/ui/screens/user/issued.dart';
import 'package:library_app/ui/screens/user/profile.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomNavigator extends StatelessWidget {
  BottomNavigator({Key key}) : super(key: key);
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [UserDashboard(), Issued(), Profile()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Dashboard"),
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        activeColorPrimary: Color(0xff0e2f56),
        inactiveColorPrimary: Colors.black38,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.book),
        title: ("Issued Books"),
        activeColorPrimary: Color(0xff0e2f56),
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        inactiveColorPrimary: Colors.black38,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: Color(0xff0e2f56),
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        inactiveColorPrimary: Colors.black38,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style9, // Choose the nav bar style with this property.
    );
  }
}
