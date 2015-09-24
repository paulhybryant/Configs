
## $Id: cpp2dia_output.tcl,v 1.5 2003/05/14 09:20:00 codemangler Exp $

#######################################################
## Copyright (c) 2001-2003 Achim Mueller
## 
## This software is provided 'as-is', without any 
## express or implied warranty. In no event will the 
## authors be held liable for any damages arising from 
## the use of this software.
## 
## Permission is granted to anyone to use this software 
## for any purpose, including commercial applications, 
## and to alter it and redistribute it freely, subject 
## to the following restrictions:
## 
## 1. The origin of this software must not be 
## misrepresented; you must not claim that you wrote 
## the original software. If you use this software in 
## a product, an acknowledgment in the product 
## documentation would be appreciated but is not 
## required.
## 
## 2. Altered source versions must be plainly marked as 
## such, and must not be misrepresented as being the 
## original software.
## 
## 3. This notice may not be removed or altered from 
## any source distribution.
## 
#######################################################


#####################################################
##
## drawIdent
##
#####################################################
proc drawIdent {iIdent} {
	set res ""
	for {set i 0} {$i < $iIdent} { incr i} {
		append res "  "
	}
	return $res
}


###############################################
##
## CreateXMLObj
##
###############################################
proc CreateXMLObj {paXMLTree sTag lArgs} {
	upvar $paXMLTree aXMLTree
	set counter 0
	if {[info exists aXMLTree(counter)]} {
		set counter $aXMLTree(counter)
	}
	set aXMLTree($counter,tag) $sTag
	set aXMLTree($counter,args) $lArgs
	set aXMLTree($counter,childs) ""
	set aXMLTree($counter,parent) ""
	incr counter
	set aXMLTree(counter) $counter
	return [expr $counter-1]
}



###############################################
##
## AddXMLChildObj
##
###############################################
proc AddXMLChildObj {paXMLTree oParent oChild} {
	upvar $paXMLTree aXMLTree
	if {![info exists aXMLTree($oParent,tag)]} {
		error "Parent object '$oParent' does not exist!"
		return TCL_ERROR
	}
	if {![info exists aXMLTree($oChild,tag)]} {
		error "Child object '$oChild' does not exist!"
		return TCL_ERROR
	}
	if {$aXMLTree($oParent,childs) == ""} {
		lappend aXMLTree($oParent,childs) "XML"
	}
	lappend aXMLTree($oParent,childs) $oChild
	set aXMLTree($oChild,parent) $oParent 
	return TCL_OK
}



###############################################
##
## AddXMLSiblingObj
##
###############################################
proc AddXMLSiblingObj {paXMLTree oObject oSibling} {
	upvar $paXMLTree aXMLTree
	if {![info exists aXMLTree($oObject,tag)]} {
		error "object does not exist!"
		return TCL_ERROR
	}
	if {![info exists aXMLTree($oSibling,tag)]} {
		error "Sibling object does not exist!"
		return TCL_ERROR
	}
	set oParent $aXMLTree($oObject,parent) 
	
	if {![info exists aXMLTree($oParent,tag)]} {
		error "Parent object does not exist!"
		return TCL_ERROR
	}

	if {$aXMLTree($oParent,childs) == ""} {
		lappend aXMLTree($oParent,childs) "XML"
	}
	lappend aXMLTree($oParent,childs) $oSibling
	set aXMLTree($oSibling,parent) $oParent 
	return TCL_OK
}


###############################################
##
## SetXMLpcdata
##
###############################################
proc SetXMLpcdata {paXMLTree oObject sPcdata} {
	upvar $paXMLTree aXMLTree
	if {![info exists aXMLTree($oObject,tag)]} {
		error "object does not exist!"
		return TCL_ERROR
	}
	set aXMLTree($oObject,childs) [list "PCDATA" $sPcdata]
	return TCL_OK
}


###############################################
##
## SetXMLTag
##
###############################################
proc SetXMLTag {paXMLTree oObject sTag} {
	upvar $paXMLTree aXMLTree
	if {![info exists aXMLTree($oObject,tag)]} {
		error "object does not exist!"
		return TCL_ERROR
	}
	set aXMLTree($oObject,tag) $sTag
	return TCL_OK
}


###############################################
##
## AddXMLArgs
##
###############################################
proc AddXMLArgs {paXMLTree oObject sNam sVal} {
	upvar $paXMLTree aXMLTree
	if {![info exists aXMLTree($oObject,tag)]} {
		error "object does not exist!"
		return TCL_ERROR
	}
	lappend aXMLTree($oObject,args) $sNam $sVal
	return TCL_OK
}


###############################################
##
## AddXMLArgs
##
###############################################
proc AddXMLArgs {paXMLTree oObject sNam sVal} {
	upvar $paXMLTree aXMLTree
	if {![info exists aXMLTree($oObject,tag)]} {
		error "object does not exist!"
		return TCL_ERROR
	}
	set aXMLTree($oObject,args) [list $sNam $sVal]
	return TCL_OK
}
	

#####################################################
##
## WriteXMLStringTag
##
#####################################################
proc WriteXMLStringTag {paXMLTree id iIdent} {
	upvar $paXMLTree aXMLTree
	set tag $aXMLTree($id,tag) 
	set sText [lindex $aXMLTree($id,childs) 1]
	set res ""
	if {$sText == ""} {
		append res [drawIdent $iIdent] {<} $tag {/>} "\n"
	} else {
		append res [drawIdent $iIdent] {<} $tag {>#} [htmlsubst $sText] {#</} $tag {>} "\n"
	}
	return $res
}
	

#####################################################
##
## WriteXMLString2Tag
##
#####################################################
proc WriteXMLString2Tag {paXMLTree id iIdent} {
	upvar $paXMLTree aXMLTree
	set tag $aXMLTree($id,tag) 
	set sText [lindex $aXMLTree($id,childs) 1]
	set res ""
	append res [drawIdent $iIdent] {<dia:string>#} [htmlsubst $sText] {#</dia:string>} "\n"
	return $res
}


###############################################
##
## WriteXML
##
###############################################
proc WriteXMLTag {paXMLTree id ident} {
	upvar $paXMLTree aXMLTree
	set ident1 [expr $ident +1]
	set tag $aXMLTree($id,tag) 
	set args $aXMLTree($id,args) 
	set childs $aXMLTree($id,childs)
	set sArgs ""
	set res ""
	if {$tag == "dia:string"} {
		return [WriteXMLStringTag aXMLTree $id $ident]
	}
	if {$tag == "dia:string2"} {
		return [WriteXMLString2Tag aXMLTree $id $ident]
	}
	foreach {nam val} $args {
		append sArgs " " $nam "=\"" [htmlsubst $val] "\""
	}
	set nochilds 1
	set childtype "PCDATA"
	if {[llength childs] > 0} {
		set childtype [lindex $childs 0]
		set childs [lreplace $childs 0 0]
		if {[llength $childs] > 0} {
			set nochilds 0
		}
	}
	##puts "$tag: $nochilds"
	if {$nochilds} {
		append res [drawIdent $ident] "<" $tag $sArgs "/>" "\n"
	} else {
		append res [drawIdent $ident] "<" $tag $sArgs ">"
		if {$childtype == "PCDATA"} {
			append res [htmlsubst [lindex $childs 0]]
		} else {
			append res "\n"
			foreach child $childs {
				append res [WriteXMLTag aXMLTree $child $ident1]
			}
		}
		append res [drawIdent $ident] "</" $tag ">" "\n"
	}
	return $res
}


###############################################
##
## WriteXML
##
###############################################
proc WriteXML {paXMLTree} {
	upvar $paXMLTree aXMLTree
	set res "<?xml version=\"1.0\"?>\n"
	set id 0
	set ident 0
	append res [WriteXMLTag aXMLTree $id $ident]
	
	return $res
}

######################################################################
######################################################################
##
##  DIA specific helper-functions
##
######################################################################
######################################################################


#####################################################
##
## AddDIAAttribChild
##
#####################################################
proc AddDIAAttribChild {paDiaTree oParent sName lData} {
	upvar $paDiaTree aDiaTree
	if {![info exists aDiaTree($oParent,tag)]} {
		error "Parent object does not exist!"
		return TCL_ERROR
	}
	set xmlAttrib [CreateXMLObj aDiaTree "dia:attribute" [list "name" $sName] ]
	AddXMLChildObj aDiaTree $oParent $xmlAttrib 	
	foreach {typ val} $lData {
		set typ "dia:$typ"
		if {$typ == "dia:string"} {
			set xmlChild [CreateXMLObj aDiaTree $typ [list] ]
			SetXMLpcdata aDiaTree $xmlChild $val
		} elseif {$typ == "dia:string2"} {
			set xmlChild [CreateXMLObj aDiaTree $typ [list] ]
			SetXMLpcdata aDiaTree $xmlChild $val
		} else {
			set xmlChild [CreateXMLObj aDiaTree $typ [list "val" $val] ]
		}
		AddXMLChildObj aDiaTree $xmlAttrib $xmlChild		
	}
	return $xmlAttrib
}


#####################################################
##
## AddDIAAttribCompositeChild
##
#####################################################
proc AddDIAAttribCompositeChild {paDiaTree oParent sName} {
	upvar $paDiaTree aDiaTree
	if {![info exists aDiaTree($oParent,tag)]} {
		error "Parent object does not exist!"
		return TCL_ERROR
	}
	set xmlAttrib [CreateXMLObj aDiaTree "dia:attribute" [list "name" $sName] ]
	AddXMLChildObj aDiaTree $oParent $xmlAttrib 	
	set xmlComposite [CreateXMLObj aDiaTree "dia:composite" [list "type" $sName] ]
	AddXMLChildObj aDiaTree $xmlAttrib $xmlComposite	
	return $xmlComposite
}


#####################################################
##
## CreateDIADiagramdata
##
#####################################################
proc CreateDIADiagramdata {paDiaTree} {
	upvar $paDiaTree aDiaTree
	set xmlDiagramdata [CreateXMLObj aDiaTree "dia:diagramdata" [list] ]
	
	AddDIAAttribChild aDiaTree $xmlDiagramdata "background" [list "color" "#ffffff"]
	set xmlCompositePaper [AddDIAAttribCompositeChild aDiaTree $xmlDiagramdata "paper"]
	AddDIAAttribChild aDiaTree $xmlCompositePaper "name" [list "string" "A4"]
	AddDIAAttribChild aDiaTree $xmlCompositePaper "tmargin" [list "real" "1.5"]
	AddDIAAttribChild aDiaTree $xmlCompositePaper "bmargin" [list "real" "1.5"]
	AddDIAAttribChild aDiaTree $xmlCompositePaper "lmargin" [list "real" "1.5"]
	AddDIAAttribChild aDiaTree $xmlCompositePaper "rmargin" [list "real" "1.5"]
	AddDIAAttribChild aDiaTree $xmlCompositePaper "is_portrait" [list "boolean" "true"]
	AddDIAAttribChild aDiaTree $xmlCompositePaper "scaling" [list "real" "0.17"]
	AddDIAAttribChild aDiaTree $xmlCompositePaper "scaling" [list "boolean" "false"]
	set xmlCompositGrid [AddDIAAttribCompositeChild aDiaTree $xmlDiagramdata "grid"]
	AddDIAAttribChild aDiaTree $xmlCompositGrid "width_x" [list "real" "1"]
	AddDIAAttribChild aDiaTree $xmlCompositGrid "width_y" [list "real" "1"]
	AddDIAAttribChild aDiaTree $xmlCompositGrid "visible_x" [list "int" "1"]
	AddDIAAttribChild aDiaTree $xmlCompositGrid "visible_y" [list "int" "1"]
	set xmlCompositGuides [AddDIAAttribCompositeChild aDiaTree $xmlDiagramdata "guides"]
	AddDIAAttribChild aDiaTree $xmlCompositGuides "hguides" [list]
	AddDIAAttribChild aDiaTree $xmlCompositGuides "vguides" [list]
	
	return $xmlDiagramdata
}


#####################################################
##
## CreateDIAParameters
##
#####################################################
proc CreateDIAParameters {paDiaTree lParams} {
	upvar $paDiaTree aDiaTree
	set xmlParameters [CreateXMLObj aDiaTree "dia:attribute" [list "name" "parameters"] ]
	foreach sAttr $lParams {		
		set xmlUMLParams [CreateXMLObj aDiaTree "dia:composite" [list "type" "umlparameter"] ]
		AddXMLChildObj aDiaTree $xmlParameters $xmlUMLParams	

		AddDIAAttribChild aDiaTree $xmlUMLParams "name" [list "string2" [lindex $sAttr 0]]
		AddDIAAttribChild aDiaTree $xmlUMLParams "type" [list "string2" [lindex $sAttr 1]]
		AddDIAAttribChild aDiaTree $xmlUMLParams "value" [list "string" [lindex $sAttr 2]]
		AddDIAAttribChild aDiaTree $xmlUMLParams "kind" [list "enum" "0"]
	}	
	return $xmlParameters
}


#####################################################
##
## CreateDIAAttributes
##
#####################################################
proc CreateDIAAttributes {paDiaTree sClass paClassData} {
	upvar $paDiaTree aDiaTree
	upvar $paClassData aClassData
	set xmlAttributes [CreateXMLObj aDiaTree "dia:attribute" [list "name" "attributes"] ]
	foreach {access sVisibility} $::lAccessOrder {		
		foreach sAttr [lsort -dictionary [array names aClassData "$sClass,attrib,$access,*"]] {
			set id $aClassData($sAttr)
			set xmlUMLAttrib [CreateXMLObj aDiaTree "dia:composite" [list "type" "umlattribute"] ]
			AddXMLChildObj aDiaTree $xmlAttributes $xmlUMLAttrib	
			AddDIAAttribChild aDiaTree $xmlUMLAttrib "name" [list "string2" $::aAttribs($id,name)]
			AddDIAAttribChild aDiaTree $xmlUMLAttrib "type" [list "string2" $::aAttribs($id,type)]
			AddDIAAttribChild aDiaTree $xmlUMLAttrib "value" [list "string" ""]
			AddDIAAttribChild aDiaTree $xmlUMLAttrib "visibility" [list "enum" $sVisibility]
			AddDIAAttribChild aDiaTree $xmlUMLAttrib "abstract" [list "boolean" "false"]
			AddDIAAttribChild aDiaTree $xmlUMLAttrib "class_scope" [list "boolean" "false"]
		}
	}	
	return $xmlAttributes
}


#####################################################
##
## CreateDIAOperations
##
#####################################################
proc CreateDIAOperations {paDiaTree sClass paClassData} {
	upvar $paDiaTree aDiaTree
	upvar $paClassData aClassData
	set xmlOperations [CreateXMLObj aDiaTree "dia:attribute" [list "name" "operations"] ]
	foreach {access sVisibility} $::lAccessOrder {
		foreach sAttr [lsort -dictionary [array names aClassData "$sClass,method,$access,*"]] {
			set id $aClassData($sAttr)
			set sType $::aMethods($id,type)
			set sName $::aMethods($id,name)
			set sAbstract $::aMethods($id,abstract)
			set lArgs $::aMethods($id,args)			
			set bIsVirtual $::aMethods($id,virtual)
			if {$bIsVirtual && $::aConfig(syntax_prefixVirtual)} {
				set sName "v:${sName}"
			}

			set xmlUMLOp [CreateXMLObj aDiaTree "dia:composite" [list "type" "umloperation"] ]
			AddXMLChildObj aDiaTree $xmlOperations $xmlUMLOp	
			AddDIAAttribChild aDiaTree $xmlUMLOp "name" [list "string2" $sName]
			AddDIAAttribChild aDiaTree $xmlUMLOp "type" [list "string" $sType]
			AddDIAAttribChild aDiaTree $xmlUMLOp "visibility" [list "enum" $sVisibility]
			AddDIAAttribChild aDiaTree $xmlUMLOp "abstract" [list "boolean" $sAbstract]
			AddDIAAttribChild aDiaTree $xmlUMLOp "class_scope" [list "boolean" "false"]
			AddXMLChildObj aDiaTree $xmlUMLOp [CreateDIAParameters aDiaTree $lArgs]
		}
	}	
	return $xmlOperations
}


#####################################################
##
## CreateDIAClass
##
#####################################################
proc CreateDIAClass {paDiaTree sClass paClassData} {
	upvar $paDiaTree aDiaTree
	upvar $paClassData aClassData
	
	set x $aClassData($sClass,pos,x)
	set y $aClassData($sClass,pos,y)
	set width $aClassData($sClass,width)
	set height $aClassData($sClass,height)
	set classid $aClassData($sClass,id)
	set stereotype $aClassData($sClass,stereotype)
	set isTemplate $aClassData($sClass,istemplate)
	set templateargs $aClassData($sClass,templateargs)
	set abstract $aClassData($sClass,abstract)

	set lData [list]
	lappend lData "type" "UML - Class"
	lappend lData "version" "0"
	lappend lData "id" $classid
	
	set xmlClass [CreateXMLObj aDiaTree "dia:object" $lData ]
	AddDIAAttribChild aDiaTree $xmlClass "obj_pos" [list "point" "${x},${y}"]
	AddDIAAttribChild aDiaTree $xmlClass "obj_bb" [list "rectangle" "${x},${y};[expr $x +$width],[expr $y +$height]"]
	AddDIAAttribChild aDiaTree $xmlClass "elem_corner" [list "point" "${x},${y}"]
	AddDIAAttribChild aDiaTree $xmlClass "elem_width" [list "real" $width]
	AddDIAAttribChild aDiaTree $xmlClass "elem_height" [list "real" "$height"]
	AddDIAAttribChild aDiaTree $xmlClass "name" [list "string" $aClassData($sClass,name)]
	AddDIAAttribChild aDiaTree $xmlClass "stereotype" [list "string" $stereotype]
	AddDIAAttribChild aDiaTree $xmlClass "abstract" [list "boolean" $abstract]
	AddDIAAttribChild aDiaTree $xmlClass "suppress_attributes" [list "boolean" "false"]
	AddDIAAttribChild aDiaTree $xmlClass "suppress_operations" [list "boolean" "false"]
	AddDIAAttribChild aDiaTree $xmlClass "visible_attributes" [list "boolean" "true"]
	AddDIAAttribChild aDiaTree $xmlClass "visible_operations" [list "boolean" "true"]
	AddDIAAttribChild aDiaTree $xmlClass "foreground_color" [list "color" "#000000"]
	AddDIAAttribChild aDiaTree $xmlClass "background_color" [list "color" "#ffffff"]
	AddXMLChildObj aDiaTree $xmlClass [CreateDIAAttributes aDiaTree $sClass aClassData]
	AddXMLChildObj aDiaTree $xmlClass [CreateDIAOperations aDiaTree $sClass aClassData]
	if {$isTemplate} {
		AddDIAAttribChild aDiaTree $xmlClass "template" [list "boolean" "true"]
		set xmlTemplates [CreateXMLObj aDiaTree "dia:attribute" [list "name" "templates"] ]
		AddXMLChildObj aDiaTree $xmlClass $xmlTemplates
		foreach arg $templateargs {
			set sTemplName [lindex $arg 0]
			set sTemplType [lindex $arg 1]
			set xmlUMLformalparam [CreateXMLObj aDiaTree "dia:composite" [list "type" "umlformalparameter"] ]
			AddDIAAttribChild aDiaTree $xmlUMLformalparam "name" [list "string2" $sTemplName]
			AddDIAAttribChild aDiaTree $xmlUMLformalparam "type" [list "string" $sTemplType]
			AddXMLChildObj aDiaTree $xmlTemplates $xmlUMLformalparam
		}
	} else {
		AddDIAAttribChild aDiaTree $xmlClass "template" [list "boolean" "false"]
		AddDIAAttribChild aDiaTree $xmlClass "templates" [list]
	}
	return $xmlClass
}	


#####################################################
##
## CreateDIAGeneralization
##
#####################################################
proc CreateDIAGeneralization {paDiaTree sClass paClassData sSuperClass iCounter} {
	upvar $paDiaTree aDiaTree
	upvar $paClassData aClassData
	
	set deltay 1.4
	if {![info exists aClassData($sClass,pos,x)]} {
		##error "Class '$sClass' does not exist!"
		return ""
	}
	if {![info exists aClassData($sSuperClass,pos,x)]} {
		##error "Parent class '$sSuperClass' does not exist!"
		return ""
	}
	
	set iCx $aClassData($sClass,pos,x)
	set iCy $aClassData($sClass,pos,y)
	set iCw $aClassData($sClass,width)
	set iCw2 [expr $aClassData($sClass,width) / 2.0]
	set iCh $aClassData($sClass,height)
	set iCb [expr $iCy + $iCh] 
	set iCl [expr $iCx + $iCw] 

	set iSCx $aClassData($sSuperClass,pos,x)
	set iSCy $aClassData($sSuperClass,pos,y)
	set iSCw $aClassData($sSuperClass,width)
	set iSCw2 [expr $aClassData($sSuperClass,width) / 2.0]
	set iSCh $aClassData($sSuperClass,height)
	set iSCb [expr $iSCy + $iSCh] 
	set iSCl [expr $iSCx + $iSCw] 

	if {[expr $iCb + $deltay] < $iSCy} {
		set starty $iSCy
		set startx [expr $iSCx + $iSCw2]
		set endx [expr $iCx + $iCw2]
		set endy $iCb
		set handleC 6
		set handleSC 1
		set centerx [expr ($startx+$endx) / 2.0]
		set centery [expr (($starty-1.0)+$endy) / 2.0]
	} elseif {[expr $iCy - $deltay] > $iSCb} {
		set starty $iSCb
		set startx [expr $iSCx + $iSCw2] 
		set endx [expr $iCx + $iCw2]
		set endy $iCy
		set handleC 1
		set handleSC 6
		set centerx [expr ($startx+$endx) / 2.0]
		set centery [expr (($starty+1.0)+$endy) / 2.0]
	} elseif {[expr abs($iCy-$iSCy)] < [expr abs($iCb-$iSCb)]} {
		set starty $iSCy
		set startx [expr $iSCx + $iSCw2]
		set endx [expr $iCx + $iCw2]
		set endy $iCy
		set handleC 1
		set handleSC 1
		set centerx [expr ($startx+$endx) / 2.0]
		if {$iSCy > $iCy} {
			set centery [expr $iCy - $deltay]
		} else {
			set centery [expr $iSCy - $deltay]
		}
	} else {
		set starty $iSCb
		set startx [expr $iSCx + $iSCw2]
		set endx [expr $iCx + $iCw2]
		set endy $iCb
		set handleC 6
		set handleSC 6
		set centerx [expr ($startx+$endx) / 2.0]
		if {$iSCb > $iCb} {
			set centery [expr $iSCy + $deltay]
		} else {
			set centery [expr $iCy + $deltay]
		}
	}
	
	set lData [list]
	lappend lData "type" "UML - Generalization"
	lappend lData "version" "0"
	lappend lData "id" "O$iCounter"
	
	set xmlGeneral [CreateXMLObj aDiaTree "dia:object" $lData ]
	AddDIAAttribChild aDiaTree $xmlGeneral "obj_pos" [list "point" "${startx},${starty}"]
	AddDIAAttribChild aDiaTree $xmlGeneral "obj_bb" [list "rectangle" "${startx},${starty};${endx},${endy}"]
	set lData [list]
	lappend lData "point" "${startx},${starty}"
	lappend lData "point" "${startx},${centery}"
	lappend lData "point" "${endx},${centery}"
	lappend lData "point" "${endx},${endy}"
	AddDIAAttribChild aDiaTree $xmlGeneral "orth_points" $lData
	set lData [list]
	lappend lData "enum" "1"
	lappend lData "enum" "0"
	lappend lData "enum" "1"
	AddDIAAttribChild aDiaTree $xmlGeneral "orth_orient" $lData
	AddDIAAttribChild aDiaTree $xmlGeneral "name" [list "string" ""]
	AddDIAAttribChild aDiaTree $xmlGeneral "name" [list "stereotype" ""]
	set xmlConnections [CreateXMLObj aDiaTree "dia:connections" "" ]
	AddXMLChildObj aDiaTree $xmlGeneral $xmlConnections	
	set lData [list]
	lappend lData "handle" "0"
	lappend lData "to" $aClassData($sSuperClass,id)
	lappend lData "connection" $handleSC
	AddXMLChildObj aDiaTree $xmlConnections [CreateXMLObj aDiaTree "dia:connection" $lData]

	set lData [list]
	lappend lData "handle" "1"
	lappend lData "to" $aClassData($sClass,id)
	lappend lData "connection" $handleC
	AddXMLChildObj aDiaTree $xmlConnections [CreateXMLObj aDiaTree "dia:connection" $lData]
	
	return $xmlGeneral
}


#####################################################
##
## CreateDIAAssociation
##
#####################################################
proc CreateDIAAssociation {paDiaTree sid paClassData paAssociations} {
	upvar $paDiaTree aDiaTree
	upvar $paClassData aClassData
	upvar $paAssociations aAssociations

	## set aAssociations($counter,to) $sClass
	## set aAssociations($counter,from) $datatype
	
	set sClass $aAssociations($sid,from)
	set sSuperClass $aAssociations($sid,to)
	set handleSC $aAssociations($sid,handle)
	
	
	set deltax 1.8
	
	set iCx $aClassData($sClass,pos,x)
	set iCy $aClassData($sClass,pos,y)
	set iCw $aClassData($sClass,width)
	set iCw2 [expr $aClassData($sClass,width) / 2.0]
	set iCh $aClassData($sClass,height)
	set iCb [expr $iCy + $iCh] 
	set iCl [expr $iCx + $iCw] 

	set iSCx $aClassData($sSuperClass,pos,x)
	set iSCy $aClassData($sSuperClass,pos,y)
	set iSCw $aClassData($sSuperClass,width)
	set iSCw2 [expr $aClassData($sSuperClass,width) / 2.0]
	set iSCh $aClassData($sSuperClass,height)
	set iSCb [expr $iSCy + $iSCh] 
	set iSCl [expr $iSCx + $iSCw] 

	set endy [expr $iSCy + 2.0 + (($handleSC / 2 - 4) * $::Courirheight)]
	if {[expr $iSCx+$iSCw2] > [expr $iCx+$iCw2]} {
		set endx $iSCx
	} else {
		set endx $iSCl
		incr handleSC
	}

	set startx [expr $iCx + $iCw2]
	if {[expr abs($iCy-($iSCy+2.0))] < [expr abs($iCb-($iSCy+2.0))]} {
		set starty $iCy
		set handleC 1
	} else {
		set starty $iCb
		set handleC 6
	}
	
	set lData [list]
	lappend lData "type" "UML - Association"
	lappend lData "version" "0"
	lappend lData "id" "O$sid"
	
	set xmlAssoz [CreateXMLObj aDiaTree "dia:object" $lData ]
	AddDIAAttribChild aDiaTree $xmlAssoz "obj_pos" [list "point" "${startx},${starty}"]
	AddDIAAttribChild aDiaTree $xmlAssoz "obj_bb" [list "rectangle" "${startx},${starty};${endx},${endy}"]
	set lData [list]
	lappend lData "point" "${startx},${starty}"
	lappend lData "point" "${startx},${endy}"
	lappend lData "point" "${endx},${endy}"
	AddDIAAttribChild aDiaTree $xmlAssoz "orth_points" $lData
	set lData [list]
	lappend lData "enum" "1"
	lappend lData "enum" "0"
	AddDIAAttribChild aDiaTree $xmlAssoz "orth_orient" $lData
	AddDIAAttribChild aDiaTree $xmlAssoz "name" [list "string" ""]
	AddDIAAttribChild aDiaTree $xmlAssoz "direction" [list "enum" "0"]
	set xmlends [CreateXMLObj aDiaTree "dia:attribute" [list "name" "ends"] ]
	AddXMLChildObj aDiaTree $xmlAssoz $xmlends
	set xmlcomposite [CreateXMLObj aDiaTree "dia:composite" [list] ]
	AddXMLChildObj aDiaTree $xmlends $xmlcomposite
	AddDIAAttribChild aDiaTree $xmlcomposite "role" [list "string" ""]
	AddDIAAttribChild aDiaTree $xmlcomposite "multiplicity" [list "string" ""]
	AddDIAAttribChild aDiaTree $xmlcomposite "arrow" [list "boolean" "false"]
	AddDIAAttribChild aDiaTree $xmlcomposite "aggregate" [list "enum" "0"]
	set xmlcomposite [CreateXMLObj aDiaTree "dia:composite" [list] ]
	AddXMLChildObj aDiaTree $xmlends $xmlcomposite
	AddDIAAttribChild aDiaTree $xmlcomposite "role" [list "string" ""]
	AddDIAAttribChild aDiaTree $xmlcomposite "multiplicity" [list "string" ""]
	AddDIAAttribChild aDiaTree $xmlcomposite "arrow" [list "boolean" "false"]
	AddDIAAttribChild aDiaTree $xmlcomposite "aggregate" [list "enum" "1"]

	set xmlConnections [CreateXMLObj aDiaTree "dia:connections" "" ]
	AddXMLChildObj aDiaTree $xmlAssoz $xmlConnections	

	set lData [list]
	lappend lData "handle" "0"
	lappend lData "to" $aClassData($sClass,id)
	lappend lData "connection" $handleC
	AddXMLChildObj aDiaTree $xmlConnections [CreateXMLObj aDiaTree "dia:connection" $lData]

	set lData [list]
	lappend lData "handle" "1"
	lappend lData "to" $aClassData($sSuperClass,id)
	lappend lData "connection" $handleSC
	AddXMLChildObj aDiaTree $xmlConnections [CreateXMLObj aDiaTree "dia:connection" $lData]
	return $xmlAssoz
}

