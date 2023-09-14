
/*
* Created by Linus_Dev (Twitter: https://twitter.com/Linus_Dev)
*
* Do only edit and share this if you have permission by the Owner Linus_Dev
* Don`t upload any of the content and don`t provide anything of it on any website
* Do only share the orginal Download link and don`t create your own one.
* Do not copy or partly copy the code
*
* Of course you can edit it for private use.
*
* last edited on 04.01.2018
*/


vec3 calculateSurfaceNormal(highp vec3 chunkedPos){
	//use opengl es build in function to fix prcision issue.
	//also use chunkedPos here because it is much more exact
	highp vec3 normal = normalize(cross(dFdx(chunkedPos), dFdy(chunkedPos)));
	return normal;
}
