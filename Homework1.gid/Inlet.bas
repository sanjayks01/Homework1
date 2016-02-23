*if(*ndime==2)
*set cond Inlet_2D *nodes
*loop nodes *onlyincond
  *nodesnum *\  
*end loop
*end if

*if(*ndime==3)
*set cond Inlet_3D *nodes
*loop nodes *onlyincond
  *nodesnum *\  
*end loop
*end if