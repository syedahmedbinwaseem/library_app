import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_app/ui/screens/user/dashboard.dart';
import 'package:library_app/ui/screens/user/issued.dart';
import 'package:library_app/ui/screens/user/localUser.dart';
import 'package:library_app/ui/screens/user/notifications.dart';
import 'package:library_app/ui/screens/user/profile.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomNavigator extends StatefulWidget {
  BottomNavigator({Key key}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  List<Widget> _buildScreens() {
    return [UserDashboard(), Issued(), Notifications(), Profile()];
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
        icon: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(LocalUser.userData.email)
                .collection('fine')
                .where('seen', isEqualTo: false)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return !snapshot.hasData
                  ? Icon(Icons.notifications)
                  : snapshot.data.docs.isEmpty
                      ? Icon(Icons.notifications)
                      : Badge(
                          badgeContent:
                              Text(snapshot.data.docs.length.toString()),
                          child: Icon(Icons.notifications),
                        );
            }),
        title: ("Notifications"),
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

// class BottomNavigator extends StatelessWidget {
//   BottomNavigator({Key key}) : super(key: key);
//   final PersistentTabController _controller =
//       PersistentTabController(initialIndex: 0);

//   List<Widget> _buildScreens() {
//     return [UserDashboard(), Issued(), Notifications(), Profile()];
//   }

//   List<PersistentBottomNavBarItem> _navBarsItems() {
//     return [
//       PersistentBottomNavBarItem(
//         icon: Icon(Icons.home),
//         title: ("Dashboard"),
//         textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
//         activeColorPrimary: Color(0xff0e2f56),
//         inactiveColorPrimary: Colors.black38,
//       ),
//       PersistentBottomNavBarItem(
//         icon: Icon(Icons.book),
//         title: ("Issued Books"),
//         activeColorPrimary: Color(0xff0e2f56),
//         textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
//         inactiveColorPrimary: Colors.black38,
//       ),
//       PersistentBottomNavBarItem(
//         icon: Icon(Icons.notifications),
//         title: ("Notifications"),
//         activeColorPrimary: Color(0xff0e2f56),
//         textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
//         inactiveColorPrimary: Colors.black38,
//       ),
//       PersistentBottomNavBarItem(
//         icon: Icon(Icons.person),
//         title: ("Profile"),
//         activeColorPrimary: Color(0xff0e2f56),
//         textStyle: TextStyle(color: Colors.black, fontFamily: 'Sofia'),
//         inactiveColorPrimary: Colors.black38,
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PersistentTabView(
//       context,
//       controller: _controller,
//       screens: _buildScreens(),
//       items: _navBarsItems(),
//       confineInSafeArea: true,
//       backgroundColor: Colors.white,
//       handleAndroidBackButtonPress: true,
//       resizeToAvoidBottomInset:
//           true, // This needs to be true if you want to move up the screen when keyboard appears.
//       stateManagement: true,
//       hideNavigationBarWhenKeyboardShows:
//           true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
//       decoration: NavBarDecoration(
//         borderRadius: BorderRadius.circular(10.0),
//         colorBehindNavBar: Colors.white,
//       ),
//       popAllScreensOnTapOfSelectedTab: true,
//       popActionScreens: PopActionScreensType.all,
//       itemAnimationProperties: ItemAnimationProperties(
//         // Navigation Bar's items animation properties.
//         duration: Duration(milliseconds: 200),
//         curve: Curves.ease,
//       ),
//       screenTransitionAnimation: ScreenTransitionAnimation(
//         // Screen transition animation on change of selected tab.
//         animateTabTransition: true,
//         curve: Curves.ease,
//         duration: Duration(milliseconds: 200),
//       ),
//       navBarStyle:
//           NavBarStyle.style9, // Choose the nav bar style with this property.
//     );
//   }
// }
