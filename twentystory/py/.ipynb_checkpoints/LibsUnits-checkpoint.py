# --------------------------------------------------------------------------------------------------
# LibUnits.py -- define system of units
#		Silvia Mazzoni & Frank McKenna, 2006
#
# Modified by @siwalan for personal purposes (Metric data). 
# Correctness not guaranteed (at least for my addition). Use it at your own discretion

# define UNITS ----------------------------------------------------------------------------
import math

meter = 1;
mm = 1/1000;

N = 1;
inch = 25.4*mm;
ft  = 12*inch;
kip = 4448.226*N;
sec = 1.0;
MPa = N/(mm**2) ;
GPa = 1000.0 * MPa ;
ksi = kip/(inch**2) ;

LunitTXT = "meter";			# define basic-unit text for output
FunitTXT = "Newton";			# define basic-unit text for output
TunitTXT = "sec";			# define basic-unit text for output

PI = math.pi
g = 32.2*ft/(sec**2) ;	# gravitational acceleration
kg = 1*sec**2/meter;
kgf = (kg*g); # Asume Newton Second Meter
ton = 1000.0 *kg;
tonf = ton*g;
Ubig = 1.e10; 			# a really large number
Usmall = 1/Ubig; 		# a really small number
