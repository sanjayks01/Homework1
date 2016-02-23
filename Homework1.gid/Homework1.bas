#Dimension
*ndime

# nodes data

*npoin       # number of nodes
*if(ndime==2)
#.nodes       X-coord  Y-coord
*loop nodes 
 *nodesnum     *nodescoord(1)  *nodescoord(2)
*end nodes
*end if
*if(ndime==3)
#.nodes       X-coord  Y-coord  Z-coord
*loop nodes 
 *nodesnum     *nodescoord(1)  *nodescoord(2)  *nodescoord(3)
*end nodes
*end if


# element data

*nelem                        # number of elements 

#.elmnt j1     j2    Ax     Asy     Asz     Jx     Iy     Iz     E     G     roll  density
*#       .      .     mm^2   mm^2    mm^2    mm^4   mm^4   mm^4   MPa   MPa   deg   tonne/mm^3
*loop elems
*elemsnum  *elemsconec(1)  *elemsconec(2)  *elemsmatprop(1,real)  *elemsmatprop(2,real)  *elemsmatprop(3,real)  *elemsmatprop(4,real)  *elemsmatprop(5,real)  *elemsmatprop(6,real)  *elemsmatprop(7,real)  *elemsmatprop(8,real)  *elemsmatprop(9,real)  *elemsmatprop(10,real)
*end elems 


*gendata(3)        # 1=Do, 0=Don't include shear deformation effects
*gendata(4)        # 1=Do, 0=Don't include geometric stiffness effects
*gendata(5)        # exaggeration factor for static mesh deformations
*gendata(6)        # zoom scale for 3D plotting
*gendata(7)        # length of x-axis increment for frame element internal force data, mm
		   # if dx is -1 then internal force calculations are skipped


*loop intervals
# Begin Static Load Case *loopvar of *nintervals  

# gravitational acceleration for self-weight loading, mm/s^2 (global)
#   gX         gY         gZ
*#   mm/s^2     mm/s^2     mm/s^2
    *intvdata(1)         *intvdata(2)         *intvdata(3)   

*set cond Loaded_joint *nodes
*condnumentities                   # number of loaded joints (global)
*if(condnumentities)
#.joint  X-load   Y-load   Z-load   X-mom     Y-mom     Z-mom
*#         N        N        N        N.mm      N.mm      N.mm
*loop nodes *onlyincond
  *nodesnum    *cond(1)    *cond(2)    *cond(3)    *cond(4)    *cond(5)    *cond(6)
*end nodes
*end if

*set cond Uniformly_distributed *elems
*condnumentities                   # number of uniformly-distributed element loads (local)
*if(condnumentities)
#.elmnt  X-load   Y-load   Z-load   uniform member loads in member coordinates
*#         N/mm     N/mm     N/mm
*loop elems *onlyincond
  *elemsnum    *cond(1)    *cond(2)    *cond(3)
*end elems
*end if

*set cond Trapezoidally_distributed *elems
*condnumentities                   # number of trapezoidally-distributed element loads (local)
*if(condnumentities)
#       start    stop     start    stop
#.elmnt loc'n    loc'n    load     load
*#       mm       mm       N/mm     N/mm
*loop elems *onlyincond
  *elemsnum  *cond(1)   *cond(2)   *cond(3)   *cond(4)  # locations and loads - local x-axis
	*cond(5)   *cond(6)   *cond(7)   *cond(8)  # locations and loads - local y-axis
	*cond(9)   *cond(10)   *cond(11)   *cond(12)  # locations and loads - local z-axis
*end elems
*end if

*set cond Concentrated_point *elems
*condnumentities                   # number of concentrated interior point loads (local)
*if(condnumentities)
#.elmnt  X-load   Y-load   Z-load    x-loc'n  point loads in member coordinates 
*loop elems *onlyincond
   *elemsnum  *cond(1)   *cond(2)   *cond(3)   *cond(4)   # x=distance from coordinate J1 (0 < x < L)    
*end elems
*end if

*set cond Temperature_changes *elems
*condnumentities                   # number of frame elements with temperature changes (local)
*if(condnumentities)
#.elmnt   coef.  y-depth  z-depth  deltaTy+  deltaTy-  deltaTz+  deltaTz-
*#         /deg.C  mm       mm       deg.C     deg.C     deg.C     deg.C
*loop elems *onlyincond
  *elemsnum    *cond(1)    *cond(2)    *cond(3)    *cond(4)    *cond(5)    *cond(6)    *cond(7) 
*end elems
*end if

*set cond Prescribed_displacement *nodes
*condnumentities                 # number of prescribed displacements nD<=nR (global)
*if(condnumentities)
#.jnt    X-displ  Y-displ  Z-displ  X-rot'n   Y-rot'n   Z-rot'n
*#         mm       mm       mm       radian    radian    radian
*loop nodes *onlyincond
  *nodesnum    *cond(1)    *cond(2)    *cond(3)    *cond(4)    *cond(5)    *cond(6)
*end nodes
*end if

# End Static Load Case *loopvar of *nintervals
*end intervals