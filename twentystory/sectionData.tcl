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

proc Boxsection { secID matID b h t nfdw nftw nfbf nftf {Orient ZZ}} {

    # TcL Function to Create A Box Section Fiber
    # Written by @siwalan
    # Modified by Wsection.tcl from Remo M. de Souza
    # Last Modified : 22 June 2022
    # input parameters
    # secID - section ID number
    # matID - material ID number 
    # b  = width of the box section - outer to outer
    # h  = depth of the box section - outer to outer
    # t  = thickness of box section

    # nfdw = number of fibers along web depth 
    # nftw = number of fibers along web thickness
    # nfbf = number of fibers along flange width
    # nftf = number of fibers along flange thickness

    # Verification
    # https://colab.research.google.com/drive/1ON3gC6S8utZsz3_9NCWQMD3ES37c1KVI?usp=sharing
    
    if {$Orient == "Weak" || $Orient == "YY" } {
        set bb [expr $b - 2 * $t]

        set y1 [expr  $b/2.0]
        set y2 [expr  $bb/2.0]
        set y3 [expr -$bb/2.0]
        set y4 [expr -$b/2.0]
	
        set hh [expr $h - 2 * $t]
        set z1 [expr -$h/2.0]
        set z2 [expr -$hh/2.0]
        set z3 [expr  $hh/2.0]
        set z4 [expr  $h/2.0]

        section fiberSec  $secID  {
            patch quadr  $matID  $nfdw $nftw  $y1 $z1 $y1 $z4 $y2 $z4 $y2 $z1
            patch quadr  $matID  $nfbf $nftf  $y2 $z1 $y2 $z2 $y3 $z2 $y3 $z1
            patch quadr  $matID  $nfbf $nftf  $y2 $z3 $y2 $z4 $y3 $z4 $y3 $z3
            patch quadr  $matID  $nfdw $nftw  $y3 $z1 $y3 $z4 $y4 $z4 $y4 $z1
        }
	
    } else {
        set hh [expr $h - 2 * $t]

        set y1 [expr  $h/2.0]
        set y2 [expr  $hh/2.0]
        set y3 [expr -$hh/2.0]
        set y4 [expr -$h/2.0]
	
        set bb [expr $b - 2 * $t]
        set z1 [expr -$b/2.0]
        set z2 [expr -$bb/2.0]
        set z3 [expr  $bb/2.0]
        set z4 [expr  $b/2.0]
        
        section fiberSec  $secID  {
            patch quadr  $matID  $nfdw $nftw  $y1 $z1 $y1 $z4 $y2 $z4 $y2 $z1
            patch quadr  $matID  $nfbf $nftf  $y2 $z1 $y2 $z2 $y3 $z2 $y3 $z1
            patch quadr  $matID  $nfbf $nftf  $y2 $z3 $y2 $z4 $y3 $z4 $y3 $z3
            patch quadr  $matID  $nfdw $nftw  $y3 $z1 $y3 $z4 $y4 $z4 $y4 $z1
        }
    }
}

set nfdw 4;		# number of fibers along web depth 
set nftw 1;		# number of fibers along web thickness
set nfbf 1;		# number of fibers along flange width
set nftf 4;		# number of fibers along flange thickness

##### Columns

##### W24x335
set d [expr 27.5*$in];	# depth
set tw [expr 1.38*$in];	# web thickness
set bf [expr 13.5*$in];	# flange width
set tf [expr 2.48*$in];	# flange thickness
Wsection  1 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W24x279
set d [expr 26.7*$in];	# depth
set tw [expr 1.16*$in];	# web thickness
set bf [expr 13.3*$in];	# flange width
set tf [expr 2.09*$in];	# flange thickness
Wsection  2 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W24x229
set d [expr 26.0*$in];	# depth
set tw [expr 0.96*$in];	# web thickness
set bf [expr 13.1*$in];	# flange width
set tf [expr 1.73*$in];	# flange thickness
Wsection  3 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W24x162
set d [expr 25.0*$in];	# depth
set tw [expr 0.705*$in];	# web thickness
set bf [expr 13.0*$in];	# flange width
set tf [expr 1.22*$in];	# flange thickness
Wsection  4 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W24x117
set d [expr 24.3*$in];	# depth
set tw [expr 0.550*$in];	# web thickness
set bf [expr 12.8*$in];	# flange width
set tf [expr 0.850*$in];	# flange thickness
Wsection  5 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W24x94
set d [expr 24.3*$in];	# depth
set tw [expr 0.515*$in];	# web thickness
set bf [expr 9.07*$in];	# flange width
set tf [expr 0.875*$in];	# flange thickness
Wsection  6 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 


##### 15x15x2
set b [expr 15.0*$in];	# Box Width / Flange
set h [expr 15.0*$in];	# Box Height / Web
set t [expr 2.0*$in];	# thickness
Boxsection  7 1 $b $h $t $nfdw $nftw $nfbf $nftf 

##### 15x15x1.25
set b [expr 15.0*$in];	# Box Width / Flange
set h [expr 15.0*$in];	# Box Height / Web
set t [expr 1.25*$in];	# thickness
Boxsection  8 1 $b $h $t $nfdw $nftw $nfbf $nftf 

##### 15x15x1.0
set b [expr 15.0*$in];	# Box Width / Flange
set h [expr 15.0*$in];	# Box Height / Web
set t [expr 1.0*$in];	# thickness
Boxsection  9 1 $b $h $t $nfdw $nftw $nfbf $nftf 

##### 15x15x0.75
set b [expr 15.0*$in];	# Box Width / Flange
set h [expr 15.0*$in];	# Box Height / Web
set t [expr 0.75*$in];	# thickness
Boxsection  10 1 $b $h $t $nfdw $nftw $nfbf $nftf 

##### 15x15x0.50
set b [expr 15.0*$in];	# Box Width / Flange
set h [expr 15.0*$in];	# Box Height / Web
set t [expr 0.5*$in];	# thickness
Boxsection  11 1 $b $h $t $nfdw $nftw $nfbf $nftf 

###########
# Beam
###########

##### W14x22
set d [expr 13.7*$in];	# depth
set tw [expr 0.230*$in];	# web thickness
set bf [expr 5.0*$in];	# flange width
set tf [expr 0.335*$in];	# flange thickness
Wsection  12 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W30x99
set d [expr 29.7*$in];	# depth
set tw [expr 0.520*$in];	# web thickness
set bf [expr 10.50*$in];	# flange width
set tf [expr 0.670*$in];	# flange thickness
Wsection  13 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 


##### W30x108
set d [expr 29.80*$in];	# depth
set tw [expr 0.545*$in];	# web thickness
set bf [expr 10.50*$in];	# flange width
set tf [expr 0.760*$in];	# flange thickness
Wsection  14 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W27x84
set d [expr 26.7*$in];	# depth
set tw [expr 0.460*$in];	# web thickness
set bf [expr 10.99*$in];	# flange width
set tf [expr 0.640*$in];	# flange thickness
Wsection  15 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W24x62
set d [expr 23.7*$in];	# depth
set tw [expr 0.430*$in];	# web thickness
set bf [expr 7.04*$in];	# flange width
set tf [expr 0.590*$in];	# flange thickness
Wsection  16 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 

##### W21x50
set d [expr 20.8*$in];	# depth
set tw [expr 0.375*$in];	# web thickness
set bf [expr 6.53*$in];	# flange width
set tf [expr 0.535*$in];	# flange thickness
Wsection  17 1 $d $bf $tf $tw $nfdw $nftw $nfbf $nftf 
