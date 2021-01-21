import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Components/restaurantWidget.dart';

class RestaurantCategoryScreen extends StatefulWidget {
  @override
  _RestaurantCategoryScreenState createState() => _RestaurantCategoryScreenState();
}

class _RestaurantCategoryScreenState extends State<RestaurantCategoryScreen> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<int> restaurants = [1,2,3,4,5,6,7,8,9,0];

  Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      key: _scaffoldKey,
      appBar: _appBar(),
      body: body(),
    );
  }
  AppBar _appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      title: Text("مطاعم"),
      elevation: 0.4,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: ()=> Navigator.of(context).pop(),
      ),
    );
  }

  Widget body(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width*0.02),
      itemCount: restaurants.length,
      itemBuilder: (context,i){
        return RestaurantWidget();
      },
    );
  }
}
