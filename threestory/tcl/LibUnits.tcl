# --------------------------------------------------------------------------------------------------
# LibUnits.tcl -- define system of units
#		Silvia Mazzoni & Frank McKenna, 2006
#
# Modified by @siwalan for personal purposes (Metric data). 
# Correctness not guaranteed (at least for my addition). Use it at your own discretion

# define UNITS ----------------------------------------------------------------------------
set meter 1000.;
set mm [expr 1];

#set mm [expr 1.0];
#set meter [expr 1000*$mm];
set N 1.;
set inch [expr 25.4*$mm];
set in [expr 25.4*$mm];
set ft [expr 12*$inch]
set kip [expr 4448.226*$N];
set sec 1.;
set MPa [expr $N/pow($mm,2)];
set GPa [expr 1000.0 * $MPa]
set kip [expr 4.44822 * 1000.0 * $N]
set ksi [expr $kip/pow($in,2)];

set LunitTXT "mm";			# define basic-unit text for output
set FunitTXT "Newton";			# define basic-unit text for output
set TunitTXT "sec";			# define basic-unit text for output

set PI [expr 2*asin(1.0)]; 		# define constants
set g [expr 32.2*$ft/pow($sec,2)]; 	# gravitational acceleration
set kg [expr 1*pow($sec,2)/$meter]
set kgf [expr $kg*$g]; # Asume Newton Second Meter
set ton [expr 1000.0 *$kg]
set tonf [expr $ton*$g]
set Ubig 1.e10; 			# a really large number
set Usmall [expr 1/$Ubig]; 		# a really small number
