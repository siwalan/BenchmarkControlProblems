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

    set dw [expr $d - 2 * $tf]
    set y1 [expr -$d/2.0]
    set y2 [expr -$dw/2.0]
    set y3 [expr  $dw/2.0]
    set y4 [expr  $d/2.0]
    
    set z1 [expr -$bf/2.0]
    set z2 [expr -$tw/2.0]
    set z3 [expr  $tw/2.0]
    set z4 [expr  $bf/2.0]

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

set nfdw 4;		# number of fibers along web depth 
set nftw 1;		# number of fibers along web thickness
set nfbf 1;		# number of fibers along flange width
set nftf 4;		# number of fibers along flange thickness

##### Columns

##### W14x370
set d [expr 17.9*$in];	# depth
set tw [expr 1.66*$in];	# web thickness
set bf [expr 16.5*$in];	# flange width
set tf [expr 2.66*$in];	# flange thickness
Wsection  1 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W14x500
set d [expr 19.6*$in];	# depth
set tw [expr 2.19*$in];	# web thickness
set bf [expr 17.0*$in];	# flange width
set tf [expr 3.50*$in];	# flange thickness
Wsection  2 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W14x455
set d [expr 19.0*$in];	# depth
set tw [expr 2.02*$in];	# web thickness
set bf [expr 16.8*$in];	# flange width
set tf [expr 3.21*$in];	# flange thickness
Wsection  3 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W14x283
set d [expr 16.7*$in];	# depth
set tw [expr 1.29*$in];	# web thickness
set bf [expr 16.1*$in];	# flange width
set tf [expr 2.07*$in];	# flange thickness
Wsection  4 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W14x257
set d [expr 16.4*$in];	# depth
set tw [expr 1.18*$in];	# web thickness
set bf [expr 16.0*$in];	# flange width
set tf [expr 1.89*$in];	# flange thickness
Wsection  5 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W14x233
set d [expr 16.0*$in];	# depth
set tw [expr 1.07*$in];	# web thickness
set bf [expr 15.9*$in];	# flange width
set tf [expr 1.72*$in];	# flange thickness
Wsection  6 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 


##### Beams

##### W36x160
set d [expr 36.0*$in];	# depth
set tw [expr 0.650*$in];	# web thickness
set bf [expr 12.0*$in];	# flange width
set tf [expr 1.02*$in];	# flange thickness
Wsection  7 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W36x135
set d [expr 35.6*$in];	# depth
set tw [expr 0.60*$in];	# web thickness
set bf [expr 12.0*$in];	# flange width
set tf [expr 0.790*$in];	# flange thickness
Wsection  8 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W30x99
set d [expr 29.7*$in];	# depth
set tw [expr 0.520*$in];	# web thickness
set bf [expr 10.5*$in];	# flange width
set tf [expr 0.670*$in];	# flange thickness
Wsection  9 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W27x84
set d [expr 26.7*$in];	# depth
set tw [expr 0.460*$in];	# web thickness
set bf [expr 10.0*$in];	# flange width
set tf [expr 0.640*$in];	# flange thickness
Wsection  10 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W24x68
set d [expr 23.7*$in];	# depth
set tw [expr 0.415*$in];	# web thickness
set bf [expr 8.97*$in];	# flange width
set tf [expr 0.585*$in];	# flange thickness
Wsection  11 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 
