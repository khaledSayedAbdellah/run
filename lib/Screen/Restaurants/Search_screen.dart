import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Components/restaurantWidget.dart';

class SearchScreen extends StatefulWidget {
  final String searchText;
  SearchScreen({this.searchText});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _searchController = TextEditingController();
  List<int> searchResult;

  Future getSearchData(String searchText)async{
    //todo do something
    print(searchText);
    setState(() {
      searchResult = [1,2,3,4,5,6,7];
    });
  }

  @override
  void initState() {
    if(widget.searchText.length>0)
      getSearchData(widget.searchText);
    super.initState();
  }

  Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: body(),
      appBar: _appBar(),
    );
  }

  AppBar _appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: screenSize.width*0.002,
      title: Text("البحث",style: TextStyle(fontWeight: FontWeight.normal),),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.close,size: screenSize.width*0.08,color: Colors.grey.shade700,),
        onPressed: ()=> Navigator.of(context).pop(),
      ),
    );
  }

  Widget body(){
    return Column(
      children: [
        searchWidget(),
        Divider(height: 0,),
        locationWidget(),
        Divider(height: 0,),
        searchResult!=null? searchInfo(): Container(),
        Expanded(
          child: restaurantsWidget(),
        ),
      ],
    );
  }

  Widget searchWidget(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(screenSize.aspectRatio*15),
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
                getSearchData(_searchController.text);
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
          getSearchData(_searchController.text);
        },
      ),
    );
  }

  Widget locationWidget(){
    return Container(
      padding: EdgeInsets.all(screenSize.width*0.02),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width*0.0225),
            child: Icon(
              Icons.location_on_outlined,
            color: Colors.grey.shade600,
              size: screenSize.aspectRatio*65,
            ),
          ),
          Text("طريق المدينة المنورة , الفيصلية",style: TextStyle(color: Colors.grey.shade800),),
        ],
      ),
    );
  }

  Widget searchInfo(){
    return Container(
      padding: EdgeInsets.all(screenSize.width*0.03),
      margin: EdgeInsets.symmetric(horizontal: screenSize.width*0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('100 نتيجة بحث ل "سلطان دي لايت"',
            style: TextStyle(fontSize: 14,color: Colors.grey),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.filter_list,size: screenSize.width*0.065,
                color: Colors.grey.shade600,),
              Text("اعدادات البحث",
                  style: TextStyle(height:1.7,fontSize: 14,color: Colors.grey.shade600)),
            ],
          )
        ],
      ),
    );
  }

  Widget restaurantsWidget(){
    return Container(
      color: Colors.blueGrey.shade50,
      child: searchResult==null?
      Container():
      searchResult.length==0?
      Container(
        child: Center(
          child: Text("لا يوجد بيانات"),
        ),
      ):
      ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width*0.02),
        itemCount: searchResult.length,
        itemBuilder: (context,i){
          return RestaurantWidget();
        },
      ),
    );
  }
}
