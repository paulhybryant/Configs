
## $Id: cpp2dia_procs.tcl,v 1.6 2003/05/14 09:20:00 codemangler Exp $

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


###############################################
##
## htmlsubst
##
###############################################
proc htmlsubst {word} {
  set idx 0
  set temp ""
  while {$idx < [string length $word]} {
  	set c [string index $word $idx]
	switch -exact -- $c {
		">" {append temp "&gt;" }
		"<" {append temp "&lt;" }
		"&" {append temp "&amp;" }
		"\"" {append temp "&quot;" }
		default {append temp $c}
	}
	incr idx
  }
  
  return $temp
}



###############################################
##
## firstword
##
###############################################
proc firstword {ptext} {
	upvar $ptext text
	set text [string trimleft $text]
	set buffer ""
	
	set allowedChars "abcdefghijklmnopqrstuvwxyz"
	append allowedChars "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	append allowedChars "0123456789"
	append allowedChars "_"
	
	set tokens "-=<>"
	
	set i 0
	
	if {[string index $text $i] == "\""} {
		set buffer "\""
		set text [string range $text 1 end]
		set i [string first "\"" $text]
		append buffer [string range $text 0 $i]
		set text [string range $text [expr $i+1] end]
	} else {
		if {[string first [string index $text 0] $tokens] >= 0} {
			set allowedChars $tokens
		}
		while {[string first [string index $text $i] $allowedChars] >=0} {
			incr i
		}
		## take the first char anyway
		if {$i == 0} { set i 1}
		
		set buffer [string range $text 0 [expr $i-1]]
		set text [string range $text $i end]
	}
	
	return $buffer
}

###############################################
##
## translateAccess
##
###############################################
proc translateAccess {access} {
	switch -exact -- $access {
		"private"	{set result "-"}
		"protected"	{set result "#"}
		"public"	{set result "+"}
		default		{set result "+"}
	}
	return $result	
}


###############################################
##
## buildMethodPrototype
##
###############################################
proc buildMethodPrototype {id paMethods} {
	upvar $paMethods aMethods
	
## set aClassData($sClass,method,$sAccess,$counter) "$id"
## set aMethods($id,class) $sClass
## set aMethods($id,access) $sAccess
## set aMethods($id,name) $sName
## set aMethods($id,type) $sType
## set aMethods($id,args) $sNewArgs
	
	set prototype [translateAccess $aMethods($id,access)]

	set bIsVirtual $::aMethods($id,virtual)
	if {$bIsVirtual && $::aConfig(syntax_prefixVirtual)} {
		append prototype "v:"
	}
	
	append prototype $aMethods($id,name)
	append prototype "("
	set sArgs ""
	foreach arg $aMethods($id,args) {
		set nam [lindex $arg 0]
		set typ [lindex $arg 1]
		set val [lindex $arg 2]
		if {($nam != "") && ($typ != "")} {
			append sArgs "$nam" ":" "$typ"
		} else {
			append sArgs "$nam" "$typ"
		}
		if {$val != ""} {
			append sArgs "=" "$val"
		}
		append sArgs ","
	}
	append prototype [string trim $sArgs " ,"]
	append prototype ")"
	if {$aMethods($id,type) != ""} {
		append prototype ": " $aMethods($id,type) 
	}
	append prototype "  "
	
	return $prototype
}


###############################################
##
## buildArgumentList
##
###############################################
proc buildArgumentList {psArgs paDatatypes} {
	upvar $psArgs sArgs
	upvar $paDatatypes aDatatypes
	set res ""
	foreach	arg [split $sArgs ","] {
	
		set arg [string trim $arg]
		if { ( $::aConfig(syntax_ignoreVoidArgument) == 1 ) && ( $arg == "void" ) } {
			continue
		}
		regsub -all {\t} $arg  { } arg
		set colum 0
		set Ttype ""
		set name ""
		set type ""
		set val ""
		set postfix ""
		if {[set i [string last "=" $arg]] >=0} {
			set val [string trim [string range $arg [expr $i+1] end]]
			set arg [string trim [string range $arg 0 [expr $i-1]]]
		}
		set i [string last " " $arg]
		set name [string trim [string range $arg [expr $i+1] end]]
		set arg [string trim [string range $arg 0 [expr $i-1]]]
		if {$name == "const"} {
			append postfix " " $name
			set i [string last " " $arg]
			set name [string trim [string range $arg [expr $i+1] end]]
			set arg [string trim [string range $arg 0 [expr $i-1]]]
		}
		append arg " " $postfix
		regsub -all {  } $arg { } type
		regsub { <} $type {<} type
		regsub {< } $type {<} type
		regsub { >} $type {>} type
		regsub {> } $type {>} type
		regsub { \*} $type {*} type
		regsub { \&} $type {&} type

		lappend res [list $name [string trim $type] $val]
	}
	if { ( [llength $res] == 0 ) 
		&& ( $::aConfig(syntax_ignoreVoidArgument) == 0 )} {
		set sArgs [list [list "" "void" "" ]]
	} else {
		set sArgs $res
	}
}


###############################################
##
## buildTemplateArgList
##
###############################################
proc buildTemplateArgList {psArgs paDatatypes} {
	upvar $psArgs sArgs
	upvar $paDatatypes aDatatypes
	set res ""
	regsub -all {<} $sArgs { } sArgs
	regsub -all {>} $sArgs { } sArgs

	foreach	arg [split $sArgs ","] {
	
		set arg [string trim $arg]

		regsub -all {\t} $arg  { } arg
		set i [string first " " $arg]
		set name [string trim [string range $arg [expr $i+1] end]]
		set type [string trim [string range $arg 0 [expr $i-1]]]
		
		lappend res [list $name $type]
	}
	set sArgs $res
}



###############################################
##
## buildAttribPrototype
##
###############################################
proc buildAttribPrototype {id paAttribs} {
	upvar $paAttribs aAttribs
	
## set aClassData($class,attrib,$access,$text) "$id"
## set aAttribs($id,class) $class
## set aAttribs($id,name) $text
## set aAttribs($id,access) $access
## set aAttribs($id,type) $datatype
	
	set prototype [translateAccess $aAttribs($id,access)]
	
	set nam $aAttribs($id,name)
	set typ $aAttribs($id,type)
	set val ""
	if {($nam != "") && ($typ != "")} {
		append prototype "$nam" ": " "$typ"
	} else {
		append prototype "$nam" "$typ"
	}
	if {$val != ""} {
		append prototype " = " "$val"
	}
	append prototype "  "
	
	return $prototype
}



###############################################
##
## readDotFile
##
###############################################
proc readDotFile {filename lAllClasses paClassData } {
	upvar $paClassData aClassData
	set fi2 [open $filename "r"]
	set state "getgraphtype"
	set edgetype "->"
	set line ""
	array set aDotviz {}
	while {(![eof $fi2])} {
		append  line " " [gets $fi2]
		if {$state == "getgraphtype"} {
			if {[set i [string first "\{" $line]] >=0} {
				if {[firstword line] == "graph"} {
					set edgetype "--"
				}
				set line [string trim [string range $line [expr $i +1] end]]
				set state "readgraph"
			}
		} elseif {$state == "readgraph"} {
			if {[set i [string first ";" $line]] >= 0} {
				set temp [string trim [string range $line 0 [expr $i -1 ] ] ]
				set line [string trim [string range $line [expr $i +1] end ] ]
				set node1 [firstword temp]
				set lParams [list]
				if {[set i [string first "\[" $temp] ] >= 0} {
					set j [string first "\]" $temp] 
					set params [string range $temp [expr $i+1] [expr $j-1]]
					while {[string length [string trim $params]] > 0} {
						set name [firstword params]
						set equal [firstword params]
						set value [firstword params]
						set value [string trim $value "\""]
						set params [string trim $params]
						set params [string trimleft $params ","]
						## puts "$name := $value"
						lappend lParams $name $value
					}
					set temp2 [string range $temp 0 [expr $i-1]]
					append temp2 [string range $temp [expr $j+1] end ]
					set temp $temp2
				}
				set word2 [firstword temp]
				if {$word2 == $edgetype} {
					set word2 [firstword temp]
					set aDotviz(edge,$node1,$word2) [list $node1 $word2 $edgetype $lParams]
				} else {
					if {[lsearch "node graph" $node1] == -1} {
						set aDotviz(node,$node1) [list $node1 $lParams]
					}
				}
			}
		} 
	}
	
	close $fi2
	foreach sClass $lAllClasses {
		##puts "aDotviz(node,$sClass) ==> [info exists aDotviz(node,$sClass)]"
		if {[info exists aClassData($sClass,name)] && [info exists aDotviz(node,$sClass)]} {
			foreach {name val} [lindex $aDotviz(node,$sClass) 1] {
				if {$name == "pos"} {
					set lVal [split $val ","]
					set aClassData($sClass,pos,x) [expr [lindex $lVal 0] / 2.0]
					set aClassData($sClass,pos,y) [expr [lindex $lVal 1] / 2.0]
				}
			}
		}
	}
	unset aDotviz
}



###############################################
##
## dimensionClass
##
###############################################
proc dimensionClass {sClass paClassData paMethods paAttribs} {
	upvar $paClassData aClassData
	upvar $paMethods aMethods
	upvar $paAttribs aAttribs
	set width 2.0
	set rowcounter 0
	## calc width of classname
	for {set i 0} {$i < [string length $sClass]} {incr i} {
		binary scan $i H2 hex
		if {[info exists ::aCharlen($hex)]} {
			set width [expr $width + $::aCharlen($hex)]
		} else {
			set width [expr $width + 0.57]
		}
	}
	
	##get all attrib prototypes
	foreach attrib [array names aClassData "$sClass,attrib,*"] {
		set id $aClassData($attrib)
		set length [expr [string length $aAttribs($id,prototype)] * $::CourirLen]
		if {$length > $width} {
			set width $length
		} 
		incr rowcounter
	}
	
	##get all method prototypes
	foreach method [array names aClassData "$sClass,method,*"] {
		set id $aClassData($method)
		set length [expr [string length $aMethods($id,prototype)] * $::CourirLen]
		if {$length > $width} {
			set width $length
		} 
		incr rowcounter
	}
	
	if {$aClassData($sClass,stereotype) != ""} {
		set height $::defaultHeightWithStereotype
	} else {
		set height $::defaultHeight
	}
	set height [expr $height + ($rowcounter * $::Courirheight)]	
	set aClassData($sClass,width) $width
	set aClassData($sClass,height) $height
}


set lAccessOrder [list private 1 protected 2 public 0]

###############################################
##
##this contains the length of the class name charset
##
###############################################
set defaultHeight 2.2
set defaultHeightWithStereotype 3.0
set CourirLen 0.467
set Courirheight 0.793
set aCharlen(26)  0.715; 	# '&' *
set aCharlen(2a)  0.383; 	# '*' *
set aCharlen(30)  0.550; 	# '0' *
set aCharlen(31)  0.550; 	# '1' *
set aCharlen(32)  0.550; 	# '2' *
set aCharlen(33)  0.550; 	# '3' *
set aCharlen(34)  0.550; 	# '4' *
set aCharlen(35)  0.550; 	# '5' *
set aCharlen(36)  0.550; 	# '6' *
set aCharlen(37)  0.550; 	# '7' *
set aCharlen(38)  0.550; 	# '8' *
set aCharlen(39)  0.550; 	# '9' *
set aCharlen(41)  0.700; 	# 'A' *
set aCharlen(42)  0.715; 	# 'B' *
set aCharlen(43)  0.715; 	# 'C' *
set aCharlen(44)  0.715; 	# 'D' *
set aCharlen(45)  0.665; 	# 'E' *
set aCharlen(46)  0.600; 	# 'F' *
set aCharlen(47)  0.750; 	# 'G' *
set aCharlen(48)  0.700; 	# 'H' *
set aCharlen(49)  0.266; 	# 'I' *
set aCharlen(4a)  0.550; 	# 'J' *
set aCharlen(4b)  0.715; 	# 'K' *
set aCharlen(4c)  0.600; 	# 'L' *
set aCharlen(4d)  0.815; 	# 'M' *
set aCharlen(4e)  0.715; 	# 'N' *
set aCharlen(4f)  0.750; 	# 'O' *
set aCharlen(50)  0.665; 	# 'P' *
set aCharlen(51)  0.777; 	# 'Q' *
set aCharlen(52)  0.718; 	# 'R' *
set aCharlen(53)  0.666; 	# 'S' *
set aCharlen(54)  0.600; 	# 'T' *
set aCharlen(55)  0.715; 	# 'U' *
set aCharlen(56)  0.665; 	# 'V' *
set aCharlen(57)  0.933; 	# 'W' *
set aCharlen(58)  0.666; 	# 'X' *
set aCharlen(59)  0.650; 	# 'Y' *
set aCharlen(5a)  0.582; 	# 'Z' *
set aCharlen(5f)  0.533; 	# '_' *
set aCharlen(61)  0.550; 	# 'a' *
set aCharlen(62)  0.600; 	# 'b' *
set aCharlen(63)  0.550; 	# 'c' *
set aCharlen(64)  0.600; 	# 'd' *
set aCharlen(65)  0.550; 	# 'e' *
set aCharlen(66)  0.333; 	# 'f' *
set aCharlen(67)  0.600; 	# 'g' *
set aCharlen(68)  0.600; 	# 'h' *
set aCharlen(69)  0.265; 	# 'i' *
set aCharlen(6a)  0.265; 	# 'j' *
set aCharlen(6b)  0.566; 	# 'k' *
set aCharlen(6c)  0.265; 	# 'l' *
set aCharlen(6d)  0.900; 	# 'm' *
set aCharlen(6e)  0.600; 	# 'n' *
set aCharlen(6f)  0.600; 	# 'o' *
set aCharlen(70)  0.600; 	# 'p' *
set aCharlen(71)  0.600; 	# 'q' *
set aCharlen(72)  0.383; 	# 'r' *
set aCharlen(73)  0.565; 	# 's' *
set aCharlen(74)  0.333; 	# 't' *
set aCharlen(75)  0.600; 	# 'u' *
set aCharlen(76)  0.565; 	# 'v' *
set aCharlen(77)  0.782; 	# 'w' *
set aCharlen(78)  0.565; 	# 'x' *
set aCharlen(79)  0.565; 	# 'y' *
set aCharlen(7a)  0.518; 	# 'z' *
