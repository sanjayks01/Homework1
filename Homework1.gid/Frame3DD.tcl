GiDMenu::InsertOption "Help" [list "Help Frame3DD"] 0 PREPOST {HelpWindow
"CUSTOM_HELP" "Frame3DD.gid"} "" "" insert _
GiDMenu::UpdateMenus

#GiD-tcl event automatically invoked when the calculation is finished, to convert results
proc AfterRunCalculation { basename dir problemtypedir where error errorfilename } {
    if { $error == 0 } {
	set filename [file join [lindex $dir 0] $basename].out
	if { [catch { Frame3DD::TransformResultsToGiD $filename } err] } {
	    WarnWin [= "Error %s" $err]
	}
    }
    return
}
  
#define the procedures in a separated namespace named Frame3DD
namespace eval Frame3DD {   
}
  
#auxiliary procedure used by TransformResultsToGiD
proc Frame3DD::_FileFind { fp text line } {
    set len [string length $text]
    if { [string range $line 0 $len-1] == $text } {
	return 1
    }
    while { ![eof $fp] } {
	gets $fp line           
	if { [string range $line 0 $len-1] == $text } {
	    return 1
	}
    }
    return 0
}

#procedure to convert .out file to .pos.res
proc Frame3DD::TransformResultsToGiD { filename } {
    if { ![file exists $filename] } {
	return
    }
    set fp [open $filename r]
    if { $fp == "" } {
	return
    }
    set non_numeric_values 0
    set exe_version ""
    
    set line ""        
    for {set i 0} {$i<13} {incr i} {
	gets $fp line          
	if { $i == 1 } {
	    set exe_version [lindex $line 2]
    }    
    }    
    set num_nodes [lindex $line 0]
    set num_constraints [lindex $line 2]
    set num_elements [lindex $line 5]
    set num_load_cases [lindex $line 8]
    for { set load_case 1 } { $load_case <= $num_load_cases } {incr load_case } {
	if { [Frame3DD::_FileFind $fp "L O A D   C A S E" $line] } {                 
	    if { $exe_version == "20100105" } {
		# old version
		set displacements_text "J O I N T   D I S P L A C E M E N T S"
	    } else {
		set displacements_text "N O D E   D I S P L A C E M E N T S"
	    }           
	    if { [Frame3DD::_FileFind $fp $displacements_text $line] } {                    
		gets $fp line  
		while { ![eof $fp] } {
		    gets $fp line  
		    set line [string trim $line]
		    if { ![string is digit [string index $line 0]] } {
		        break
		    }
		    lassign $line id dx dy dz rx ry rz
		    if { [string is double -strict $dx] } {
		    set Displacements($id) [list $dx $dy $dz]                    
		        set Rotations($id) [list $rx $ry $rz]
		    } else {
		        incr non_numeric_values
		    }
		}
		#to set to 0 0 0 for nodes without explicit displacement value
		for {set id 1} {$id<=$num_nodes} {incr id} {
		    if { [info exists Displacements($id)] } {
		        append values(Displacements) "$id $Displacements($id)\n"
		    } else {
		        append values(Displacements) "$id 0 0 0\n"
		    }
		    if { [info exists Rotations($id)] } {
		        append values(Rotations) "$id $Rotations($id)\n"
		    } else {
		        append values(Rotations) "$id 0 0 0\n"
		    }
		}
		unset -nocomplain Displacements
		unset -nocomplain Rotations
	       
		foreach item {Displacements Rotations} {
		    if { [info exists values($item)] } {
		    set result "Result $item Static $load_case Vector OnNodes"
		    set results($result) $values($item)
		}         
		}         
		unset -nocomplain values                
	    } else {
		break
	    }            
	    if { [Frame3DD::_FileFind $fp "F R A M E   E L E M E N T   E N D   F O R C E S" $line] } {                                           
		gets $fp line  
		while { ![eof $fp] } {
		    gets $fp line  
		    set line [string trim $line]
		    if { ![string is digit [string index $line 0]] } {
		        break
		    }
		    lassign $line element_id node_id Nx Vy Vz Txx Myy Mzz
		    foreach item {Nx Vy Vz Txx Myy Mzz} {
		        set v [set $item]
		        if { [string is double -strict $v] } {                        
		            set v [expr {-1.0*$v}]
		        append values($item) "$element_id $v\n"
		        } else {
		            incr non_numeric_values
		        }
		    }
		    gets $fp line  
		    set line [string trim $line]
		    lassign $line element_id node_id Nx Vy Vz Txx Myy Mzz                    
		    foreach item {Nx Vy Vz Txx Myy Mzz} {                        
		        set v [set $item]                 
		        if { [string is double -strict $v] } {
		        append values($item) " $v\n"
		        } else {
		            incr non_numeric_values
		        }
		    }               
		}  
		foreach item {Nx Vy Vz Txx Myy Mzz} {
		    if { [info exists values($item)] } {
		    set result "Result $item Static $load_case Scalar OnGaussPoints Beams"
		    set results($result) $values($item)         
		}   
		}   
		unset -nocomplain values                  
	    } else {
		break
	    }
	    if { [Frame3DD::_FileFind $fp "R E A C T I O N S" $line] } {                                
		gets $fp line  
		while { ![eof $fp] } {
		    gets $fp line  
		    set line [string trim $line]
		    if { ![string is digit [string index $line 0]] } {
		        break
		    }
		    lassign $line id fx fy fz mx my mz
		    if { [string is double -strict $fx] } {
		    append values(Reaction_forces) "$id $fx $fy $fz\n"
		    append values(Reaction_moments) "$id $mx $my $mz\n"
		    } else {
		        incr non_numeric_values
		}   
		}   
		foreach item {Reaction_forces Reaction_moments} {
		    if { [info exists values($item)] } {
		    set result "Result $item Static $load_case Vector OnNodes"
		    set results($result) $values($item) 
		}                
		}                
		unset -nocomplain values
	    } else {
		break
	    }   
	} else {
	    break
	}
    }

    if { [Frame3DD::_FileFind $fp "M A S S   N O R M A L I Z E D   M O D E   S H A P E S" $line] } {
	gets $fp line ;#convergence tolerance
	while { ![eof $fp] } {
	    gets $fp line
	    if { [string range $line 0 34] == "M A T R I X    I T E R A T I O N S:"} {
		break
	    }
	    set i_mode [string range [lindex $line 1] 0 end-1]
	    set frequency [lindex $line 3]
	    set period [lindex $line 6]
	    gets $fp line ;#X- modal participation factor
	    gets $fp line ;#Y- modal participation factor
	    gets $fp line ;#Z- modal participation factor
	    gets $fp line ;#Joint   X-dsp       Y-dsp       Z-dsp       X-rot       Y-rot       Z-rot
	    for { set i 1 } {$i <= $num_nodes } { incr i } {
		gets $fp line
		lassign $line id dx dy dz rx ry rz
		append values(Displacements) "$id $dx $dy $dz\n"
		append values(Rotations) "$id $rx $ry $rz\n"
	    }
	    foreach item {Displacements Rotations} {
		if { [info exists values($item)] } {
		set result "Result Modal_${item}_${frequency}_Hz Dynamic 0 Vector OnNodes"
		set results($result) $values($item) 
	    }
	    }
	    unset -nocomplain values

	}
    }

    close $fp
    
    if { [array size results] } {
	set filename_post [file rootname $filename].post.res
	set fout [open $filename_post w]
	if { $fout == "" } {       
	    return
	}        
	puts $fout "GiD Post Results File 1.0"
	puts $fout ""
	puts $fout "GaussPoints Beams ElemType Linear"
	puts $fout "Number Of Gauss Points: 2"
	puts $fout "Nodes included"
	puts $fout "Natural Coordinates: Internal"
	puts $fout "End gausspoints"        
	foreach result [array names results] {
	    puts $fout ""
	    puts $fout $result
	    puts $fout Values 
	    puts -nonewline $fout $results($result)
	    puts $fout "End values"  
	}
	close $fout
	unset -nocomplain results
    }
    
    if { $non_numeric_values } {
	WarnWin [= "Error, there are 'not a number' results"]
    }
    return
}

