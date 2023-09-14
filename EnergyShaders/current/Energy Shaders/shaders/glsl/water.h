/*
 * Copyright 2022 LinusDev
 *
 * Contact: einsuperlinus@gmail.com
 */

vec4 water(vec3 waterColor, vec3 pos, vec3 camPos, float shadow, float light, float nightDay, float rain, float darkness, vec3 N){
  vec4 outC = vec4(0.0, 0.0, 0.0, 0.0);
  outC.rgb = waterColor;

  //Calculating Transparency based on the view angle on the surface
  //The more near the view-vector is to the normal-vector
  //the more transparent is the water
  //
  //camera: O							<-That`s a face!
  //				|	\
  //				|	 \
  //________|___\_________________
  //			more less			transparent

  //Calculate water transparents (think about normalize so we dont need to divide by le)
  float transparency = 1.0;
  vec3 viewVec = pos - camPos;
  vec3 otherVec = N;
  float le = (length(viewVec) * length(otherVec));
  if(le != 0.0){ transparency = dot(viewVec, otherVec) / le; }

  transparency = (1.0 - abs(transparency)) + 0.3;

  outC.a = clamp(transparency-0.3, 0.0, 1.0);


  //Calculating the Reflection-vector based on the surface-normal-vector
  //Just using a build in function here
  //
  //camera: O					reflection-vector
  //				 \			/
  //					\	  /
  //				   \/
  // The angles on left and right must always be the same
  vec3 reflectVector = -normalize(reflect(normalize(camPos - pos), N));


  //vec3 reflection = getReflection(pos, reflectVector);


  //Now check if the reflection-vector`s y-coordinate is under 0.0
  //If this is the case we should not reflect anything because it would
  //be under the world (called End in minecraft)
  if(reflectVector.y < 0.0){
    //TODO: think about mixing
  }else{
    //outC.rgb = mix(outC.rgb, reflection, min(1.0, transparency - 0.2));
  }

  //shadow
  outC = mix(outC, outC * WATER_COLOR_IN_SHADOW_PER_CENT, shadow);

  //in Caves
  outC.rgb = mix(outC.rgb, WATER_COLOR_IN_CAVES.rgb, darkness);
  outC.a = mix(outC.a, outC.a * WATER_COLOR_IN_CAVES.a, darkness);

  //night
  outC = mix(outC, outC * WATER_COLOR_AT_NIGHT_PER_CENT, max(0.0, (nightDay) - darkness));
  return outC;
}
