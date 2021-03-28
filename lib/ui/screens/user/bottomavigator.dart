
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomNavigator extends StatelessWidget {
  BottomNavigator({Key key}) : super(key: key);
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [Dashboard(), Transactions(), Profile()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Dashboard"),
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        activeColor: Colors.teal,
        inactiveColor: Colors.black38,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart),
        title: ("Transactions"),
        activeColor: Colors.teal,
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        inactiveColor: Colors.black38,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColor: Colors.teal,
        textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
        inactiveColor: Colors.black38,
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
