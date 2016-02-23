*if(*ndime==2)
*set cond Outlet_2D *nodes
*loop nodes *onlyincond
  *nodesnum *\  
*end loop
*end if

*if(*ndime==3)
*set cond Outlet_3D *nodes
*loop nodes *onlyincond
  *nodesnum *\  
*end loop
*end if