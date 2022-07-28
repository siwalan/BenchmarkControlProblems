proc Wsection { secID matID d bf tf tw nfdw nftw nfbf nftf {Orient ZZ}} {
    # ###################################################################
    # Wsection  $secID $matID $d $bf $tf $tw $nfdw $nftw $nfbf $nftf
    # ###################################################################
    # create a standard W section given the nominal section properties
    # written: Remo M. de Souza
    # date: 06/99
    # modified: 08/99  (according to the new general modelbuilder)
    # input parameters
    # secID - section ID number
    # matID - material ID number 
    # d  = nominal depth
    # tw = web thickness
    # bf = flange width
    # tf = flange thickness
    # nfdw = number of fibers along web depth 
    # nftw = number of fibers along web thickness
    # nfbf = number of fibers along flange width
    # nftf = number of fibers along flange thickness


    if {$Orient == "Weak" || $Orient == "YY" } {
	set dw [expr $d - 2 * $tf]
	set z1 [expr -$d/2.0]
	set z2 [expr -$dw/2.0]
	set z3 [expr  $dw/2.0]
	set z4 [expr  $d/2.0]

	set y1 [expr  $bf/2.0]
	set y2 [expr  $tw/2.0]
	set y3 [expr -$tw/2.0]
	set y4 [expr -$bf/2.0]
	
	section fiberSec  $secID  {
	    patch quadr  $matID  $nfbf $nftf   $y1 $z3   $y1 $z4   $y4 $z4   $y4 $z3
	    patch quadr  $matID  $nftw $nfdw   $y2 $z3   $y3 $z3   $y3 $z2   $y2 $z2
	    patch quadr  $matID  $nfbf $nftf   $y1 $z1   $y1 $z2   $y4 $z2   $y4 $z1
	}
	
    } else {
	set dw [expr $d - 2 * $tf]
	set y1 [expr -$d/2.0]
	set y2 [expr -$dw/2.0]
	set y3 [expr  $dw/2.0]
	set y4 [expr  $d/2.0]

	set z1 [expr -$bf/2.0]
	set z2 [expr -$tw/2.0]
	set z3 [expr  $tw/2.0]
	set z4 [expr  $bf/2.0]
	
	section fiberSec  $secID  {
	    #                     nfIJ  nfJK    yI  zI    yJ  zJ    yK  zK    yL  zL
	    patch quadr  $matID  $nfbf $nftf   $y1 $z4   $y1 $z1   $y2 $z1   $y2 $z4
	    patch quadr  $matID  $nftw $nfdw   $y2 $z3   $y2 $z2   $y3 $z2   $y3 $z3
	    patch quadr  $matID  $nfbf $nftf   $y3 $z4   $y3 $z1   $y4 $z1   $y4 $z4
	}
    }
}