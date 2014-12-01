
## $Id: cpp_tokenize.tcl,v 1.2 2003/05/14 09:20:00 codemangler Exp $

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

namespace eval ::ACM::CPP {

	set lCppTokens [list /** /* */ // ++ -- -= += *= /= ^= &= |= == <= >= != || && >> << -> :: \[\] ()]
	set lCppKeyWords {	"_asm" "asm" "auto" "break" "bool" "case" "catch" "char" "class" "const" 
						"const_cast" "continue" "default" "delete" "do" "double" "dynamic_cast" 
						"else" "enum" "explicit" "extern" "false" "float" "for" "friend" "goto" 
						"if" "inline" "int" "__int8" "__int16" "__int32" "__int64" "long" "mutable" 
						"namespace" "new" "operator" "pascal" "private:" "protected:" "public:" 
						"register" "reinterpret_cast" "return" "short" "signed" "sizeof" "static"
						"static_cast" "struct" "switch" "template" "this" "throw" "true" "try" 
						"typedef" "typename" "typeid" "union" "using" "unsigned" "virtual" "void" 
						"volatile" "while" 
						}
	set lCppDataTypes {	"bool" "char" "double" "float" "int" "__int8" "__int16" "__int32" 
						"__int64" "long" "short" "void" "class" "enum" "struct" "union" "typedef"
						}
	set lCppTypeMods {	"auto" "const" "explicit" "extern" "friend" "inline" "mutable" 
						 "pascal" "register" "signed" "static" "unsigned" "virtual" 
						 "volatile" 
						}


	###############################################
	## getNextToken
	##
	## @param pline variable name of linenumber
	## @param pindex variable name of column in line
	## @param ptype variable name of type buffer 
	##
	## @return content of token
	## ptype will contain one of ( WORD, KEYWORD, NUMBER, PREP, MISC )
	##
	###############################################
	proc getNextToken {pline pindex ptype args} {
		upvar $pline line
		upvar $pindex index
		upvar $ptype type

		set temp ""
		set type ""
		set aSwitch(NoWS) 0
		set aSwitch(AllowCC) 0
		set aSwitch(AllowArrow) 0
		foreach sw $args {
			switch -exact -- $sw {
				"-noWhiteSpace" {set aSwitch(NoWS) 1}
				"-allowColonColon" {set aSwitch(AllowCC) 1}
				"-allowArrow" {set aSwitch(AllowArrow) 1}
				
			}
		}

		set len [string length $line]

		if {$index >= $len} {
			return ""
		}

		set c [string index $line $index]
		while {($c == " " || $c == "\t") && ($index < $len)} {
			if {$aSwitch(NoWS) == 0} {
				set type "SPACE"
				append temp $c
			}
			incr index 
			set c [string index $line $index]
		}

		if {$type == "SPACE"} {
			return $temp
		}

		if {($c >="A" && $c <="Z") || ($c >="a" && $c <="z") || ($c == "_")} {
			set type "WORD"
		} elseif {($c >="0" && $c <="9")} {
			set type "NUMBER"
		} elseif {($c =="#")} {
			set type "PREP"
		} else {
			set type "MISC"
		}
		append temp $c
		incr index
		set loop 1
		while { $loop } {
			set c [string index $line $index]

			if {$c == " " || $c == "\t" || $index >= $len} {
				set loop 0
				continue
			}
			incr index

			switch $type {
				"WORD" {
						set loop 0
						if {($c >="A" && $c <="Z") || 
							($c >="a" && $c <="z") || 
							($c >="0" && $c <="9") || 
							($c == "_") || ($c == ".")
							} {
							append temp $c
							set loop 1
						} elseif {($c == ":") && ($aSwitch(AllowCC) == 1)} {
							if {[string index $line $index] == ":"} {
								append temp $c ":"
								set loop 1
								incr index
							}
						} elseif {($c == "-") && ($aSwitch(AllowArrow) == 1)} {
							if {[string index $line $index] == ">"} {
								append temp $c ">"
								set loop 1
								incr index
							}
						}
						if {$loop == 0} {
							incr index -1
						}
				}
				"PREP" {
						set loop 0
						if {$c =="i" || 
							$c =="p" || 
							$c =="e" || 
							$c =="u" || 
							$c =="d" 
							} {
							append temp $c
							set loop 1
							set type "WORD"
						} else {
							set type "MISC"
						}
						if {$loop == 0} {
							incr index -1
						}
				}
				"NUMBER" {
						set loop 0
						if {($c >="0" && $c <="9") || 
							($c == ".")
							} {
							append temp $c
							set loop 1
						}
						if {$loop == 0} {
							incr index -1
						}
				}
				"MISC" {
						if {($c >="0" && $c <="9")} {
							if {$temp == "-" || $temp == "+" ||
								$temp == "-." || $temp == "+." ||
								$temp == "."} {
								set type "NUMBER"
							}
						}
						if {$type == "MISC"} {
							if {[lsearch -exact $::ACM::CPP::lCppTokens "${temp}${c}"] == -1} {
								set loop 0
							}
						}
						if {$loop == 0} {
							incr index -1
						} else {
							append temp $c
						}
				}
			}
		}

		if { $type == "WORD" } {
			if {[lsearch -exact $::ACM::CPP::lCppKeyWords $temp] >= 0} {
				set type "KEYWORD"
			}
		}
		return $temp
	}

}
