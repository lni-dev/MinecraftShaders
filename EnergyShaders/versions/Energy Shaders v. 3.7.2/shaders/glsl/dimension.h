//Author: LinusDev

//overworld 0-1
//nether 2.0
//end 3.0
float dimension(in sampler2D source, float nightDay){
  vec3 topLeftLight = texture2D(source, vec2(0.0, 0.0)).rgb;
  vec3 bottomLeftLight = texture2D(source, vec2(0.0, 1.0)).rgb;

  #ifdef UNDER_WATER
    //End's and Nether's TopLeftCorner and BottomLeftCorner are equal, but the Nether has more Red
    //Water cannot be placed in the Nether
    if(topLeftLight.r == bottomLeftLight.r){
      return 3.0;
    }
    return nightDay;
  #else

    if(topLeftLight.r == bottomLeftLight.r && topLeftLight.g == bottomLeftLight.g){

      return 3.0; //End
    }

    if(pow(topLeftLight.r, 1.0) > 0.3){
      return 2.0; //Nether
    }


    return nightDay;
  #endif
}
