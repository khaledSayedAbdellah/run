import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map_booking/Screen/Restaurants/CartOrder_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  @override
  _RestaurantDetailsScreenState createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<double> orderFood = [];
  addToCard(double price){
    setState(() {
      orderFood.add(price);
    });
  }
  double getTotal(){
    double sum = 0;
    orderFood.forEach((price) {sum+=price;});
    return sum;
  }
  Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: Stack(
        children: [
          body(),
          Positioned(
            bottom: 0, left: 0, right: 0, child: orderFood.length==0?
          Container(): completeOrder(),
          ),
        ],
      ),
    );
  }
  Widget completeOrder(){
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width*0.03,
              vertical: screenSize.width*0.02,
            ),
            color: Colors.blueGrey.shade700,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("المجموع",style: TextStyle(color: Colors.white),),
                Text("${getTotal().toStringAsFixed(2)} SR",
                  style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=> CartOrderScreen())
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
                  child: Text("اكمال الطلب", style: TextStyle(
                    color: Colors.white,fontSize: screenSize.width*0.05),)),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("سلطان دي لايت برجر",
            style: TextStyle(fontSize: 18,color: Colors.grey.shade600),),
          Text("مطاعم توصيل مجاني",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
      elevation: 0.4,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: ()=> Navigator.of(context).pop(),
      ),
    );
  }

  Widget body(){
    return Container(
      color: Colors.blueGrey.shade50,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width*0.03,
          vertical: screenSize.width*0.04,
        ),
        children: [
          imageWidget(),
          descriptionWidget(),
          restaurantInfoWidget(),
          menuWidget(),
          orderFood.length>0?
          SizedBox(height: screenSize.width*0.2):
          Container()
        ],
      ),
    );
  }

  Widget imageWidget(){
    return Container(
      height: screenSize.height*0.175,
      width: screenSize.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenSize.width*0.03),
        image: DecorationImage(
          image: NetworkImage(
            "https://mostaql.hsoubcdn.com/uploads/739729-Nhv5N-1593294262-5ef7bdb6bbd57.png",
          ),
          fit: BoxFit.fill
        ),
      ),
    );
  }


  Widget descriptionWidget(){
    return Container(
      padding: EdgeInsets.only(top: screenSize.width*0.02),
      child: Text('لوريم ايبسوم هو نموذج افتراضي يوضع في التصاميم لتعرض على العميل ليتصور طريقه وضع النصوص بالتصاميم سواء كانت تصاميم مطبوعه ... بروشور او فلاير على سبيل المثال ... او نماذج مواقع انترنت .',style: TextStyle(
        color: Colors.black54,
        fontSize: screenSize.width*0.04
      ),),
    );
  }


  Widget restaurantInfoWidget(){
    return Container(
      padding: EdgeInsets.only(top: screenSize.width*0.03),
      child: Column(
        children: [
          restaurantInfo(
            title: "عرض اراء المستخدمين",
            leading: Container(
              child: Column(
                children: [
                  Text("تقييمات المستخدمين",style: TextStyle(
                    fontSize: screenSize.width*0.035
                  ),),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RatingBar(
                        ratingWidget: RatingWidget(
                          full: Icon(Icons.star_rate),
                          half:  Icon(Icons.star_half_outlined),
                          empty:  Icon(Icons.star_border_outlined),
                        ),
                        onRatingUpdate: (value){},
                        itemCount: 5,
                        allowHalfRating: true,
                        itemSize: screenSize.width*0.055,
                        initialRating: 4.9,
                      ),
                      SizedBox(width: screenSize.width*0.01,),
                      Text("4.9",style: TextStyle(
                          fontSize: screenSize.width*0.035),),
                    ],
                  ),
                ],
              ),
            ),
            onTap: (){}
          ),
          restaurantInfo(
              title: "مفتوح",
              leading: Container(
                child: Row(
                  children: [
                    Container(
                      width: screenSize.width*0.1,
                      height: screenSize.width*0.1,
                      padding: EdgeInsets.all(screenSize.width*0.02),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade800,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Icon(Icons.location_on_outlined,color: Colors.white,)),
                    ),
                    SizedBox(width: screenSize.width*0.02,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("سلطان دي لايت برجر",style: TextStyle(
                          fontSize: screenSize.width*0.035,
                          color: Colors.black,
                        ),),
                        Text("يبعد 0.89 كم عنك",style: TextStyle(
                          fontSize: screenSize.width*0.03,
                          color: Colors.grey.shade600,
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: (){}
          ),
          restaurantInfo(
              title: "عرض الاوقات",
              leading: Container(
                child: Row(
                  children: [
                    Container(
                      width: screenSize.width*0.1,
                      height: screenSize.width*0.1,
                      padding: EdgeInsets.all(screenSize.width*0.02),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade800,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Icon(Icons.access_time,color: Colors.white,)),
                    ),
                    SizedBox(width: screenSize.width*0.02,),
                    Text("مفتوح",style: TextStyle(
                      fontSize: screenSize.width*0.035,
                      color: Colors.black,
                    ),),
                  ],
                ),
              ),
              onTap: (){}
          ),
        ],
      ),
    );
  }
  Widget restaurantInfo({Widget leading,String title,onTap}){
    return Container(
      height: screenSize.height*0.075,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Divider(color: Colors.black54),
            Spacer(),
            Row(
              children: [
                leading,
                Spacer(),
                Text(title,style: TextStyle(
                  color: Colors.amber,fontSize: screenSize.width*0.035,
                ),),
                SizedBox(width: screenSize.width*0.01,),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade600,
                  size: screenSize.width*0.04,
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }


  Widget menuWidget(){
    return Container(
      child: Column(
        children: [
          menuTitleWidget(),
          ...[1,2].map((e){
            return showFoodWidget();
          }).toList()
        ],
      ),
    );
  }
  Widget menuTitleWidget(){
    return Container(
      height: screenSize.width*0.15,
      child: OverflowBox(
        maxWidth: screenSize.width,
        child: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: screenSize.width*0.03),
          color: Colors.grey.shade300,
          child: Text("القائمة",style: TextStyle(color: Colors.black),),
        ),
      ),
    );
  }
  Widget showFoodWidget(){
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: screenSize.width*0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("برجر"),
                    RotatedBox(
                      quarterTurns: 15,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey.shade600,
                        size: screenSize.width*0.05,
                      ),
                    ),
                  ],
                ),
              ),
              ...[1,2].map((e){
                return foodWidget();
              }).toList(),
            ],
          ),
        ),
        Container(
          height: screenSize.width*0.1,
          child: OverflowBox(
            maxWidth: screenSize.width,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: screenSize.width*0.03),
              color: Colors.grey.shade300,
            ),
          ),
        )
      ],
    );
  }
  Widget foodWidget(){
    return InkWell(
      onTap: _addFoodToCard,
      child: Container(
        height: screenSize.width*0.265,
        child: Column(
          children: [
            Divider(color: Colors.black,height: 0,),
            Spacer(),
            Row(
              children: [
                Container(
                  width: screenSize.width*0.25,
                  height: screenSize.width*0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenSize.width*0.03),
                    image: DecorationImage(
                        image: NetworkImage(
                          "https://st2.depositphotos.com/3957801/5642/i/600/depositphotos_56423065-stock-photo-bacon-burger.jpg",
                        ),
                        fit: BoxFit.fill
                    ),
                  ),
                ),
                SizedBox(width: screenSize.width*0.02,),
                Container(
                  height: screenSize.width*0.175,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("برجر سلطان",style: TextStyle(
                          fontSize: screenSize.width*0.04,color: Colors.black),),
                      Text("ساندوتش خرافي",style: TextStyle(
                          fontSize: screenSize.width*0.035,color: Colors.grey.shade800),),
                      Text("100.00 ريال",style: TextStyle(
                          fontSize: screenSize.width*0.03,color: Colors.amber),),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
  void _addFoodToCard() async {
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      context: context,
      builder: (context) {
        return AddFoodToCard(
          onTap: addToCard,
        );
      },
    );
  }
}

class AddFoodToCard extends StatefulWidget {
  final Function onTap;
  AddFoodToCard({this.onTap});
  @override
  _AddFoodToCardState createState() => _AddFoodToCardState();
}

class _AddFoodToCardState extends State<AddFoodToCard> {

  double price = 50;
  int count = 1;

  addToCard(){
    widget.onTap(price*count);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(screenSize.width*0.1),
          topRight: Radius.circular(screenSize.width*0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //SizedBox(height: screenSize.width*0.02,),
          Padding(
            padding: EdgeInsets.only(top:  screenSize.width*0.02),
            child: Row(
              children: [
                Spacer(flex: 1,),
                Text("برجر السلطان",style: TextStyle(
                  color: Colors.black54,fontSize: screenSize.width*0.045
                ),),
                Spacer(flex: 5,),
                InkWell(
                  onTap: ()=>  Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    color: Colors.black54,
                    size: screenSize.width*0.075,
                  ),
                ),
                Spacer(flex: 1,),
              ],
            ),
          ),
          Image.network(
            "https://st2.depositphotos.com/3957801/5642/i/600/depositphotos_56423065-stock-photo-bacon-burger.jpg",
            width: screenSize.width,
            height: screenSize.width*0.4,
            fit: BoxFit.cover,
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: screenSize.width*0.03),
            child: Text("برجر السلطان ذات المذاق الرائع المقدم من السلطان",style: TextStyle(
                color: Colors.grey.shade800,fontSize: screenSize.width*0.035
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
                  width: screenSize.width*0.1,
                  height: screenSize.width*0.1,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.grey.shade200
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              Container(
                width: screenSize.width*0.3,
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
                  width: screenSize.width*0.1,
                  height: screenSize.width*0.1,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      color: Colors.grey.shade200
                  ),
                  child: Icon(
                    Icons.remove,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Text("SR ${(count*price).toStringAsFixed(2)}",style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: screenSize.width*0.04
            ),),
          ),
          InkWell(
            onTap: addToCard,
            child: Container(
              height: screenSize.width*0.15,
              width: screenSize.width*0.9,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade800,
                borderRadius: BorderRadius.circular(screenSize.width*0.1)
              ),
              child: Center(child: Text("اضافه",style: TextStyle(
                color: Colors.white,fontSize: screenSize.width*0.045
              ),)),
            ),
          ),
          SizedBox(height: screenSize.width*0.01,),
        ],
      ),
    );
  }

}


