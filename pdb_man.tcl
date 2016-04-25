proc mod1 {} {
	# THIS PROCEDURE READS THE INPUT PDB FILE AND ADD THE CHAIN ID IF ITS MISSING

	# space variables

	set p(1) "   "
	set p(2) "  "
	set p(3) " "
	set p(4) ""
	set p(5) ""
	
	set p1(1) "    "
	set p1(2) "   "
	set p1(3) "  "
	set p1(4) " "
	set p1(5) ""

	set c(4) "    "
	set c(5) "   "
	set c(6) "  "
	set c(7) " "
	set c(8) ""

	set sat(1) "  "
	set sat(2) " "
	set sat(3) ""
	set sat(4) ""

	set ic(1) " "
	set ic(2) " "
	set ic(3) " "
	set ic(4) ""
	
	set satn(1) "   "
	set satn(2) "  "
	set satn(3) " "
	set satn(4) " "


	set f [open "[lindex $::argv 0]" "r"]
	set data1 [read $f]
	close $f

	set test [lindex $data1 5]
	set st [string length $test]

	if { $st < 4 } { 
		set oshift 0
		puts "			# NO CHANGE"
	} else { 
		set oshift 1
		puts "				# SETIING CHAIN ID AS 'A' THROUGHOUT"
	} 

	set h [open "mod_[lindex $::argv 0]" "w"]

	set k 0

	while { $k < [llength $data1] } {
		set term [lindex $data1 $k]
		set t1 [string range $term 0 5]
		if { $term == "TER" } {
			puts $h "TER"
		}
		if { [lindex $data1 $k] == "ATOM" || $t1 == "HETATM" } {
			if { $t1 == "HETATM" } {
				set sterm [string length $term]
				if { $sterm > 6 } {
					set shift 1
					set rn1 $term
					set srn1 5
					set ft ""
				} else {
						set shift 0
						set rn1 [lindex $data1 [expr { $k + 1 }]]
						set srn1 [string length $rn1]
						set ft "HETATM"
				}
			} else { 
					set shift 0
					set rn1 [lindex $data1 [expr { $k + 1 }]]
					set srn1 [string length $rn1]
					set ft "ATOM  "
			}
		
			set atype [lindex $data1 [expr { $k + 2 - $shift}]]
			set satype [string length $atype]

			if { $satype > 5} {
				set shift2 1
				set at1 [lindex $data1 [expr { $k + 2 - $shift }]]		
				set sat1 4
				set resn ""
				set sresn 4
			} else {
				set shift2 0
				set at1 [lindex $data1 [expr { $k + 2 - $shift }]]		
				set sat1 [string length $at1]
				set resn [lindex $data1 [expr { $k + 3 - $shift}]]
				set sresn [string length $resn]
			}			

			if { $oshift == 0 } {
				set chain_id [lindex $data1 [expr { $k + 4 - $shift - $shift2}]]
				set schain_id [string length $chain_id]
			} else { 
				set chain_id "A"
				set schain_id 1
			}

			if { $schain_id > 1 } {
				set shift1 1
				set an1 [lindex $data1 [expr { $k + 4 - $shift - $shift2 }]]
				set san1 4
				set cn ""
			} else { 
				#set cn [lindex $data1 [expr { $k + 4 - $shift - $shift2  }]]
				set cn $chain_id
				set an1 [lindex $data1 [expr { $k + 5 -$shift - $shift2 - $oshift}]]
				set san1 [string length $an1]
				set shift1 0
			}


			set x1 [lindex $data1 [expr { $k + 6 - $shift - $shift1 -$shift2 - $oshift}]]
			set sx1 [string length $x1]
			if { $sx1 > 8 } {
				set shift3 1
				set t 0
				while { [string range $x1 $t $t] != "." } {
					incr t
				}
				set corx [string range $x1 0 [expr { $t + 3 }]]
				set cory [string range $x1 [expr { $t + 3 }] end]
				set sx1 [string length [string range $x1 0 [expr { $t + 3 }]]]
				set y1 ""
				set sy1 8
				set z1 [lindex $data1 [expr { $k + 8 - $shift -$shift1 - $shift2 - $shift3 - $oshift}]] 
				set z1 [format "%.3f" [expr { $z1 - 0.0 }]]
				set sz1 [string length $z1]
			} else { 
				set shift3 0
				set x1 [format "%.3f" [expr { $x1 - 0.0 }]]
				set sx1 [string length $x1]
				set y1 [lindex $data1 [expr { $k + 7 - $shift -$shift1 - $shift2 - $shift3 - $oshift}]] 
				set sy1 [string length $y1]
				if { $sy1 > 8 } {
					set shift4 1
					set t 0
					while { [string range $y1 $t $t] != "." } {
						incr t
					}
					set cory [string range $y1 0 [expr { $t + 3 }]]
					set corz [string range $y1 [expr { $t + 3 }] end]
					set sy1 [string length [string range $y1 0 [expr { $t + 3 }]]]
					set z1 ""
					set sz1 8
				} else {
					set shift4 0
					set y1 [format "%.3f" [expr { $y1 - 0.0 }]]
					set sy1 [string length $y1]
					set z1 [lindex $data1 [expr { $k + 8 - $shift -$shift1 - $shift2 - $shift3 - $shift4 - $oshift}]] 
					set z1 [format "%.3f" [expr { $z1 - 0.0 }]]
					set sz1 [string length $z1]
				}
			}
			if { [string length [lindex $data1 [expr { $k + 9 - $shift -$shift1 - $shift2 - $shift3 - $shift4 - $oshift}]]] > 5 } {
				set shift5 1
			} else {
				set shift5 0
			}
		
			puts $h "$ft$p1($srn1)$rn1 $ic($sat1)$at1$sat($sat1)$p($sresn)$resn $cn$p($san1)$an1    $c($sx1)$x1$c($sy1)$y1$c($sz1)$z1  1.00  0.00           [lindex $data1 [expr { $k + 11 - $shift - $shift1 - $shift2 - $shift3 - $shift4 - $shift5 - $oshift }]]"
		}
		incr k
	}
	puts $h "END"
	close $h
}

mod1
