import 'package:flutter/material.dart';


double heightSize(BuildContext context){
  final double deviceHeight = MediaQuery.of(context).size.height;
  if(deviceHeight>=650){
    return deviceHeight+(deviceHeight*.15);
  }
  else if(deviceHeight>=635 &&deviceHeight <650){
    return deviceHeight;
  }
  else if(deviceHeight >=500 && deviceHeight<=634){
    return deviceHeight+(deviceHeight*.15);
  }
else if(deviceHeight <500 && deviceHeight>=435){
  return deviceHeight+(deviceHeight*.4);
  }

  else if(deviceHeight <435){
    return deviceHeight+(deviceHeight*.7);
  }

}

double widthSize(BuildContext context) {
  final double deviceWidth = MediaQuery.of(context).size.width;

  return deviceWidth;
}