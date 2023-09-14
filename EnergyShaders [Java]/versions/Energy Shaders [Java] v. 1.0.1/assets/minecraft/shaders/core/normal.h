hvec3 calculateSurfaceNormal(hvec3 chunkedPos){
  //use opengl es build in function to fix precision issue.
  //also use chunkedPos here because it is much more exact
  hvec3 normal = -normalize(cross(dFdx(chunkedPos), dFdy(chunkedPos)));
  //ddx and ddy for hlsl
  return normal;
}
