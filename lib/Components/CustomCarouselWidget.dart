import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomCarouselWidget extends StatefulWidget {
  List<Widget> children;
  double height;
  double fraction;
  Color activeIndicatorColor;
  Color unActiveIndicatorColor;
  bool indicatorOverCarousel;
  bool autoPlay;
  bool lowSpaceBottom;

  CustomCarouselWidget({@required this.children,this.height,this.fraction,
  this.activeIndicatorColor,this.unActiveIndicatorColor,
    this.indicatorOverCarousel = false,this.autoPlay = false,
  this.lowSpaceBottom = false});

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CustomCarouselWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                child: CarouselSlider(
                  items: widget.children,
                  options: CarouselOptions(
                    autoPlay: widget.autoPlay,
                    viewportFraction: widget.fraction!=null?widget.fraction:0.9,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: true,
                    height: widget.height!=null?widget.height:
                    screenSize.height>screenSize.width?
                    screenSize.height*0.225:screenSize.height*0.625,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }
                  ),
                ),
              ),
              widget.indicatorOverCarousel?
              Positioned(
                bottom: screenSize.width*0.02,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.children.map((item) {
                    int index = widget.children.indexOf(item);
                    return Container(
                      width: screenSize.width*0.0175,
                      height: screenSize.width*0.0175,
                      margin: EdgeInsets.symmetric(
                        vertical: screenSize.width*0.02,
                        horizontal: screenSize.width*0.02,
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? widget.activeIndicatorColor!=null?
                          widget.activeIndicatorColor: Colors.white:
                          widget.unActiveIndicatorColor!=null?
                          widget.unActiveIndicatorColor: Colors.grey
                      ),
                    );
                  }).toList(),
                ),
              ):Container(),
            ],
          ),
          !widget.indicatorOverCarousel?Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.children.map((item) {
              int index = widget.children.indexOf(item);
              return Container(
                width: screenSize.width*0.0175,
                height: screenSize.width*0.0175,
                margin: EdgeInsets.symmetric(
                    vertical: widget.lowSpaceBottom?
                    screenSize.width*0.0005:screenSize.width*0.02,
                    horizontal: screenSize.width*0.02,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? widget.activeIndicatorColor!=null?
                  widget.activeIndicatorColor: Colors.white :
                  widget.unActiveIndicatorColor!=null?
                  widget.unActiveIndicatorColor: Colors.grey
                ),
              );
            }).toList(),
          ):Container(),
        ]
    );
  }
}