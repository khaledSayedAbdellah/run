import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Screen/Restaurants/PickLocation_screen.dart';

class CartOrderScreen extends StatefulWidget {
  @override
  _CartOrderScreenState createState() => _CartOrderScreenState();
}

class _CartOrderScreenState extends State<CartOrderScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List orderFood = [1,2];
  removeFood(){
    setState(() {
      orderFood.removeAt(0);
    });
  }

  Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
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
      child: Column(
        children: [
          Expanded(child: showFoodOrderWidget()),
          nextWidget(),
        ],
      ),
    );
  }

  Widget showFoodOrderWidget(){
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width*0.03,
        ),
        itemCount: orderFood.length,
        itemBuilder: (context,i){
          return FoodOrderWidget(
            onRemove: removeFood,
          );
        },
      ),
    );
  }


  Widget nextWidget(){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> PickLocationScreen())
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width*0.03,
          vertical: screenSize.width*0.02,
        ),
        width: screenSize.width,
        height: screenSize.width*0.175,
        color: Colors.blueGrey.shade900,
        child: Center(
            child: Text("التالي", style: TextStyle(
                color: Colors.white,fontSize: screenSize.width*0.05),)),
      ),
    );
  }
}

class FoodOrderWidget extends StatefulWidget {
  final Function onRemove;
  FoodOrderWidget({this.onRemove});
  @override
  _FoodOrderWidgetState createState() => _FoodOrderWidgetState();
}

class _FoodOrderWidgetState extends State<FoodOrderWidget> {

  int count = 1;
  double price = 50.0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.width*0.225,
      child: Column(
        children: [
          Spacer(),
          Row(
            children: [
              Text("برجر السلطان",style: TextStyle(
                  fontSize: screenSize.width*0.045,color: Colors.grey.shade600
              ),),
              Spacer(),
              Column(
                children: [
                  Container(
                    child: Text("SR ${(count*price).toStringAsFixed(2)}",style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: screenSize.width*0.04
                    ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          if(count<100){
                            setState(() {
                              count++;
                            });
                          }
                        },
                        child: Container(
                          width: screenSize.width*0.06,
                          height: screenSize.width*0.06,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              color: Colors.grey.shade200
                          ),
                          child: Icon(
                            Icons.add,
                            size: screenSize.width*0.045,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Container(
                        width: screenSize.width*0.1,
                        child: Center(
                          child: Text("$count",style: TextStyle(
                              color: Colors.amber,
                              fontSize: screenSize.width*0.06
                          ),),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          if(count>1){
                            setState(() {
                              count--;
                            });
                          }
                        },
                        child: Container(
                          width: screenSize.width*0.06,
                          height: screenSize.width*0.06,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              color: Colors.grey.shade200
                          ),
                          child: Icon(
                            Icons.remove,
                            size: screenSize.width*0.045,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(screenSize.width*0.01),
                height: screenSize.width*0.225,
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: widget.onRemove??(){},
                  child: Icon(
                    Icons.close,
                    color: Colors.black54,
                    size: screenSize.width*0.045,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Divider(color: Colors.black54,height: 0,),
        ],
      ),
    );
  }
}
