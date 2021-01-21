import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Components/CustomCarouselWidget.dart';
import 'package:flutter_map_booking/Screen/Restaurants/RestaurantCategory_screen.dart';
import 'package:flutter_map_booking/Screen/Restaurants/Search_screen.dart';

class RestaurantsHomeScreen extends StatefulWidget {
  @override
  _RestaurantsHomeScreenState createState() => _RestaurantsHomeScreenState();
}

class _RestaurantsHomeScreenState extends State<RestaurantsHomeScreen> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = TextEditingController();

  List categoryList = [1,2,3,4,5,6,7,8,9,0];
  Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            searchWidget(),
            Expanded(child: body())
          ],
        ),
      ),
    );
  }
  Widget searchWidget(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(screenSize.aspectRatio*10),
      alignment: Alignment.center,
      child: TextFormField(
        controller: _searchController,
        style: TextStyle(color: Colors.black,fontSize: 16),
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: "ابحث عن مطعم, كوفي او اي مكان",
          hintStyle: TextStyle(color: Colors.grey,fontSize: 16),
          icon: Padding(
            padding: EdgeInsets.only(right: screenSize.width*0.03),
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> SearchScreen(
                    searchText: _searchController.text,
                  ))
                );
              },
              child: Icon(
                Icons.search,
                size: screenSize.aspectRatio*65,
                color: Colors.grey.shade600,
              ),
            ),
          ),

        ),
        onSaved: (value){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=> SearchScreen(
                searchText: value,
              ))
          );
        },
      ),
    );
  }
  Widget body(){
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        adsWidget(),
        popularRestaurantsWidget(),
        categoriesWidget(),
        SizedBox(height: screenSize.width*0.2,),
      ],
    );
  }

  Widget adsWidget(){
    return Container(
      child: CustomCarouselWidget(
        children: [
          adsContentWidget(),
          adsContentWidget(),
          adsContentWidget(),
        ],
        height: screenSize.height*0.2,
        fraction: 1.0,
        indicatorOverCarousel: true,
      ),
    );
  }
  Widget adsContentWidget(){
    return Stack(
      children: [
        Container(
          child: Image.network(
            "https://i.pinimg.com/originals/f3/c4/81/f3c481ab08574d32eae95a90a2648048.png",
            width: screenSize.width,
            height: screenSize.height*0.2,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: screenSize.width*0.03,),
              CircleAvatar(
                radius: screenSize.width*0.08,
                backgroundImage: NetworkImage(""),
              ),
              SizedBox(width: screenSize.width*0.03,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenSize.width*0.03,),
                  Text("افرش بيتك",style:  TextStyle(color: Colors.white,fontSize: 16,),),
                  SizedBox(height: screenSize.width*0.015,),
                  Container(
                    width: screenSize.width*0.7,
                    child: Text("جددت بيتك وتحتاج لفرشه . مع رن افرش بيتك بكل سهولة",
                      style: TextStyle(color: Colors.white,fontSize: 14,),),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }


  Widget popularRestaurantsWidget(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenSize.width*0.05),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(
              top: screenSize.width*0.04,
              bottom: screenSize.width*0.03
            ),
            child: Text(
              "اشهر المواقع حولك",style: TextStyle(
              color: Colors.grey.shade800,fontSize: 16
            ),),
          ),
          Container(
            height: screenSize.width*0.25,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context,i){
                return restaurantWidget();
              },
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }
  Widget restaurantWidget(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenSize.width*0.02)
      ),
      width: screenSize.width*0.425,
      margin: EdgeInsets.only(left: screenSize.width*0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Row(
              children: [
                Image.network("https://mostaql.hsoubcdn.com/uploads/475526-kDNAz-1558750019-5ce8a343ceda2.jpg",
                width: screenSize.width*0.15,height: screenSize.width*0.15,),
                SizedBox(width: screenSize.width*0.01,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenSize.width*0.26,
                        child: Text("سلطان دي لايت برجر",style: TextStyle(fontSize: 12),)),
                    Text("مطعم",style: TextStyle(fontSize: 12)),
                    SizedBox(height: screenSize.width*0.003,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(screenSize.width*0.03)
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width*0.05,
                          vertical: screenSize.width*0.01),
                      child: Text("10% خصم",style: TextStyle(
                        color: Colors.white,
                        fontSize: 12
                      ),),
                    ),
                  ],
                ),

              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width*0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.star,color: Colors.amber,size: screenSize.width*0.05,),
                    SizedBox(width: screenSize.width*0.005,),
                    Text("9.4",style: TextStyle(height: 1,fontSize: 14,color: Colors.grey.shade600),),
                  ],
                ),
                Text("0.98 كم",style: TextStyle(height:1,fontSize: 12,fontWeight: FontWeight.bold,color: Colors.amber)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget categoriesWidget(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenSize.width*0.05),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(
              top: screenSize.width*0.05,
              bottom: screenSize.width*0.02,
            ),
            child: Text(
              "الخدمات الاكثر طلباً",style: TextStyle(
                color: Colors.grey.shade800,fontSize: 16
            ),),
          ),
          Container(
            child: Wrap(
              spacing: screenSize.width*0.075,
              runSpacing: screenSize.width*0.075,
              children: categoryList.map((e){
                return categoryWidget();
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
  Widget categoryWidget(){
    return Container(
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> RestaurantCategoryScreen())
          );
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(screenSize.width*0.02),
              child: Image.network("https://images.theconversation.com/files/270320/original/file-20190423-15218-9to8i9.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=1200.0&fit=crop",
                fit: BoxFit.cover,
                width: screenSize.width*0.4125,
              ),
            ),
            Positioned(
              bottom: 0,left: 0,right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(screenSize.width*0.02),
                      bottomLeft: Radius.circular(screenSize.width*0.02),
                    )
                ),
                height: screenSize.width*0.09,
                child: Center(child: Text("حلويات",style: TextStyle(
                    color: Colors.white,fontSize: 15
                ),)),
              ),
            )
          ],
        ),
      ),
    );
  }

}
