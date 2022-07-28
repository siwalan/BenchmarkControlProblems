set eigenValues [eigen -fullGenLapack 15]

puts "\nEigenvalues:"
set eigenValue [lindex $eigenValues 0]
puts "T[expr 0+1] = [expr 2*$PI/sqrt($eigenValue)] s; F[expr 0+1] = [expr 1/(2*$PI/sqrt($eigenValue))] hz;"
set eigenValue [lindex $eigenValues 1]
puts "T[expr 1+1] = [expr 2*$PI/sqrt($eigenValue)] s; F[expr 1+1] = [expr 1/(2*$PI/sqrt($eigenValue))] hz;"
set eigenValue [lindex $eigenValues 2]
puts "T[expr 2+1] = [expr 2*$PI/sqrt($eigenValue)]s ; F[expr 2+1] = [expr 1/(2*$PI/sqrt($eigenValue))] hz;"
set eigenValue [lindex $eigenValues 3]
puts "T[expr 3+1] = [expr 2*$PI/sqrt($eigenValue)]s ; F[expr 3+1] = [expr 1/(2*$PI/sqrt($eigenValue))] hz;"
set eigenValue [lindex $eigenValues 4]
puts "T[expr 4+1] = [expr 2*$PI/sqrt($eigenValue)]s ; F[expr 4+1] = [expr 1/(2*$PI/sqrt($eigenValue))] hz;"
set eigenValue [lindex $eigenValues 5]
puts "T[expr 5+1] = [expr 2*$PI/sqrt($eigenValue)]s ; F[expr 5+1] = [expr 1/(2*$PI/sqrt($eigenValue))] hz;"
set eigenValue [lindex $eigenValues 6]
puts "T[expr 6+1] = [expr 2*$PI/sqrt($eigenValue)]s ; F[expr 6+1] = [expr 1/(2*$PI/sqrt($eigenValue))] hz;"
set eigenValue [lindex $eigenValues 7]
puts "T[expr 7+1] = [expr 2*$PI/sqrt($eigenValue)]s ; F[expr 7+1] = [expr 1/(2*$PI/sqrt($eigenValue))] hz;"
set eigenValue [lindex $eigenValues 8]
puts "T[expr 8+1] = [expr 2*$PI/sqrt($eigenValue)]s ; F[expr 8+1] = [expr 1/(2*$PI/sqrt($eigenValue))] hz;"

set eigenValue [lindex $eigenValues 9]
puts "T[expr 9+1] = [expr 2*$PI/sqrt($eigenValue)]s ; F[expr 9+1] = [expr 1/(2*$PI/sqrt($eigenValue))] hz;"

set eigenValue [lindex $eigenValues 10]
puts "T[expr 10+1] = [expr 2*$PI/sqrt($eigenValue)]s ; F[expr 10+1] = [expr 1/(2*$PI/sqrt($eigenValue))] hz;"

set eigenValue [lindex $eigenValues 11]
puts "T[expr 11+1] = [expr 2*$PI/sqrt($eigenValue)]s ; F[expr 11+1] = [expr 1/(2*$PI/sqrt($eigenValue))] hz;"


puts "\nEigen Analysis Done"
