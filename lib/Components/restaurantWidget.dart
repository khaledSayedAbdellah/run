import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Screen/Restaurants/RestaurantDetails_screen.dart';

class RestaurantWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=> RestaurantDetailsScreen())
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenSize.width*0.02),
        height: screenSize.width*0.275,
        margin: EdgeInsets.symmetric(vertical: screenSize.width*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenSize.width*0.03)
        ),
        child:  Row(
          children: [
            Padding(
              padding: EdgeInsets.all(screenSize.width*0.02),
              child: Image.network("https://mostaql.hsoubcdn.com/uploads/475526-kDNAz-1558750019-5ce8a343ceda2.jpg",
                width: screenSize.width*0.25,height: screenSize.width*0.25,),
            ),
            SizedBox(width: screenSize.width*0.02,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: screenSize.width*0.6,
                  child: Text("سلطان دي لايت برجر",
                    style: TextStyle(fontSize: 16),),
                ),
                Text("مطاعم توصيل مجاني",
                  style: TextStyle(fontSize: 14,color: Colors.grey.shade600),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.amber,
                      size: screenSize.width*0.05,
                    ),
                    SizedBox(width: screenSize.width*0.005,),
                    Text("0.89 كم",style: TextStyle(height: 0.9,
                        fontSize: 15,color: Colors.amber),),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(screenSize.width*0.03)
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width*0.05,
                      vertical: screenSize.width*0.01),
                  child: Center(
                    child: Text("10% خصم",style: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                    ),),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
