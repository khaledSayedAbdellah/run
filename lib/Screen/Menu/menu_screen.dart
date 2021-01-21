import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Prefs/pref_manager.dart';
import 'package:flutter_map_booking/Prefs/pref_utils.dart';
import 'package:flutter_map_booking/Screen/MyProfile/profile.dart';
import 'package:flutter_map_booking/Screen/Restaurants/RestaurantHome_screen.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/language/app_language.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MenuItems {
  String name;
  IconData icon;

  MenuItems({this.icon, this.name});
}

class MenuScreens extends StatelessWidget {
  final String activeScreenName;

  MenuScreens({this.activeScreenName});

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<AppLanguage>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            margin: EdgeInsets.all(0.0),
            accountName: Text(
              PrefManager.currentUser.name,
              style: headingWhite,
            ),
            accountEmail: Text(PrefManager.currentUser.mobile),
            currentAccountPicture: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: CachedNetworkImageProvider(
                "https://source.unsplash.com/300x300/?portrait",
              ),
            ),
            onDetailsPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return ProfileScreen();
                  },
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();
                return false;
              },
              child: ListView(
                //padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      // The initial contents of the drawer.
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRoute.homeScreen,
                                  (Route<dynamic> route) => false);
                            },
                            child: Container(
                              height: 60.0,
                              color:
                                  this.activeScreenName.compareTo("HOME") == 0
                                      ? greyColor2
                                      : whiteColor,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      FontAwesomeIcons.home,
                                      color: blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      localize(context, 'home'),
                                      style: heading18Black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRoute.homeScreen2,
                                  (Route<dynamic> route) => false);
                            },
                            child: Container(
                              height: 60.0,
                              color:
                                  this.activeScreenName.compareTo("HOME2") == 0
                                      ? greyColor2
                                      : whiteColor,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      FontAwesomeIcons.home,
                                      color: blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      localize(context, 'home2'),
                                      style: heading18Black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /*GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushNamed(AppRoute.paymentMethodScreen);
                            },
                            child: Container(
                              height: 60.0,
                              color:
                                  this.activeScreenName.compareTo("PAYMENT") ==
                                          0
                                      ? greyColor2
                                      : whiteColor,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      FontAwesomeIcons.wallet,
                                      color: blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      localize(context, 'payments'),
                                      style: heading18Black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),*/
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushNamed(AppRoute.historyScreen);
                            },
                            child: Container(
                              height: 60.0,
                              color:
                                  this.activeScreenName.compareTo("HISTORY") ==
                                          0
                                      ? greyColor2
                                      : whiteColor,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      FontAwesomeIcons.history,
                                      color: blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      localize(context, 'history'),
                                      style: heading18Black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /*GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushNamed(AppRoute.notificationScreen);
                            },
                            child: Container(
                              height: 60.0,
                              color: this
                                          .activeScreenName
                                          .compareTo("NOTIFICATIONS") ==
                                      0
                                  ? greyColor2
                                  : whiteColor,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      FontAwesomeIcons.bell,
                                      color: blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      localize(context, 'notifications'),
                                      style: heading18Black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),*/


                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=>
                                      RestaurantsHomeScreen(),)
                              );
                            },
                            child: Container(
                              height: 60.0,
                              color: this.activeScreenName.compareTo("TERMS") == 0
                                  ? greyColor2 : whiteColor,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      FontAwesomeIcons.cogs,
                                      color: blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "المطاعم",
                                      style: heading18Black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),


                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushNamed(AppRoute.termsConditionsScreen);
                            },
                            child: Container(
                              height: 60.0,
                              color:
                                  this.activeScreenName.compareTo("TERMS") == 0
                                      ? greyColor2
                                      : whiteColor,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      FontAwesomeIcons.cogs,
                                      color: blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      localize(context, 'terms'),
                                      style: heading18Black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              showBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.32,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text(
                                          localize(context, 'chooseLanguage'),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Divider(),
                                        InkWell(
                                          onTap: () {
                                            langProvider.changeLanguage(Locale('ar'));
                                          },
                                          child: ListTile(
                                            leading: Image(
                                              height: 50,
                                              width: 70,
                                              image: AssetImage(
                                                  'assets/image/sa-flag.png'),
                                              fit: BoxFit.cover,
                                            ),
                                            title: Text('العربية'),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        InkWell(
                                          onTap: () {
                                            langProvider.changeLanguage(Locale('en'));
                                          },
                                          child: ListTile(
                                            leading: Image(
                                              height: 50,
                                              width: 70,
                                              image: AssetImage(
                                                  'assets/image/us-flag.png'),
                                              fit: BoxFit.cover,
                                            ),
                                            title: Text('English'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 60.0,
                              color: whiteColor,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      FontAwesomeIcons.language,
                                      color: blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      localize(context, 'language'),
                                      style: heading18Black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              PrefUtils.clearSharedPref();
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoute.loginScreen);
                            },
                            child: Container(
                              height: 60.0,
                              color: whiteColor,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      FontAwesomeIcons.signOutAlt,
                                      color: blackColor,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      localize(context, 'logout'),
                                      style: heading18Black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // The drawer's "details" view.
                    ],
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}
