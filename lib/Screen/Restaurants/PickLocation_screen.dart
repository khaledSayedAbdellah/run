import 'package:flutter/material.dart';

class PickLocationScreen extends StatefulWidget {
  @override
  _PickLocationScreenState createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: body(),
    );
  }
  AppBar _appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("طلب جديد",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600,
                fontWeight: FontWeight.normal),
          ),
          Text("سلطان دي لايت برجر",
            style: TextStyle(fontSize: 18,color: Colors.grey.shade600),),
        ],
      ),
      centerTitle: true,
      elevation: 0.4,
      leading: IconButton(
        icon: Icon(Icons.close,color: Colors.grey.shade600,),
        onPressed: ()=> Navigator.of(context).pop(),
      ),
    );
  }

  Widget body(){
    return Container(
      child: Center(
        child: Text("demo"),
      ),
    );
  }
}
