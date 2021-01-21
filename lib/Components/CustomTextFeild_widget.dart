import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: must_be_immutable
class CustomTextFieldWidget extends StatelessWidget {

  final TextEditingController controller;
  final bool obscure;
  final String hint;
  final Color backGroundColor;
  final int maxLine;
  final Function validator;
  TextInputType textInputType = TextInputType.text;
  bool enable;
  final borderColor;
  final double customHeight;
  final double borderRadiusValue;
  final EdgeInsets insidePadding;

  CustomTextFieldWidget({this.insidePadding,this.validator, this.maxLine,this.backGroundColor,this.controller,
  this.obscure = false,this.hint,this.textInputType,this.enable=true,
    this.borderColor, this.customHeight,this.borderRadiusValue});


  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      textDirection: TextDirection.rtl,
      validator: validator,
      //textAlign: TextAlign.right,
      enabled: enable,
      obscureText: obscure,
      controller: controller,
      decoration: InputDecoration(
          contentPadding: insidePadding??EdgeInsets.all(screenSize.width*0.035),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue??90.0)),
              borderSide: BorderSide(
                color: backGroundColor,
              )
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue??90.0)),
              borderSide: BorderSide(
                color: backGroundColor,
              )
          ),
          fillColor: backGroundColor,
          filled: true,

          hintText: hint,
          prefixText: "   ",
          hintStyle: TextStyle(
              fontSize: screenSize.width*0.04,
              color: Colors.grey.shade600,
              height: 0.000
          ),
          alignLabelWithHint: true
      ),
      textCapitalization: TextCapitalization.words,
      maxLines: maxLine??1,
      keyboardType: textInputType,
      style: TextStyle(fontSize: screenSize.width*0.03,
        color: Colors.black,
      ),
    );
  }
}
