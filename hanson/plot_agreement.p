set terminal post eps enh color
<<<<<<< HEAD
set output "plot_coef.eps"
set title "Reflection Coef for Al-slab Electron Albedo Problem"
set multiplot layout 2,1 rowsfirst
set tmargin at screen 0.47
=======
set terminal postscript eps enhanced
set output "plot_angular_dist.eps"
set title "15.7 MeV Electron Angular Distribution from a 9.658 {/Symbol m}m Gold Foil"
set multiplot layout 2,1 rowsfirst
set tmargin at screen 0.8
>>>>>>> 3dad22a8e60128d4f4433978748ee46d369e8ef5
set bmargin at screen 0.1
set lmargin at screen 0.12
set rmargin at screen 0.95
set format x "%3.2e"
<<<<<<< HEAD
set format y "%3.2f"
set xlabel "Energy (MeV)"
set ylabel "Reflection Coef"
set xrange[1.0E-03:5.1E-03]
#set yrange[0.0:0.18]
#set ytics( '' 0.90, 0.95, 1.0, 1.05, '' 1.10 )
#set arrow from 1e-3,1.0 to 10.0,1.0 nohead lc rgb"red" lt 2 lw 1
set key outside top center
plot "combined_reflections.txt" using 1:2:3 with errorbars title "MCNP",\
     "combined_reflections.txt" using 1:4:5 with errorbars title "FACEMC-ACE",\
     "combined_reflections.txt" using 1:6:7 with errorbars title "FACEMC-Native",\
     "combined_reflections.txt" using 1:8:9 with errorbars title "FACEMC-Moments",\
     "experimental_reflections_2.txt" using 1:2 title "Neubert",\
     "experimental_reflections_2.txt" using 1:3 title "Bishop",\
     "experimental_reflections_2.txt" using 1:4 title "Joy Ref. 2",\
     "experimental_reflections_2.txt" using 1:5 title "Joy Ref. 4",\
     "experimental_reflections_2.txt" using 1:6 title "Joy Ref. 5",\
     "experimental_reflections_2.txt" using 1:7 title "Joy Ref. 6",\
     "experimental_reflections_2.txt" using 1:8 title "Joy Ref. 14",
=======
set format y "%3.3f"
set xlabel "Angle (Degree)"
set ylabel "#/Square Degree"
set xrange[0.0:30.0]
#set yrange[0.0:0.18]
#set ytics( '' 0.90, 0.95, 1.0, 1.05, '' 1.10 )
#set arrow from 1e-3,1.0 to 10.0,1.0 nohead lc rgb"red" lt 2 lw 1
#set key outside top center
plot "computational_results.txt" using 1:2:3 with errorbars title "MCNP",\
     "computational_results.txt" using 1:4:5 with errorbars title "FACEMC-ACE",\
     "computational_results.txt" using 1:6:7 with errorbars title "FACEMC-LinLin",\
     "computational_results.txt" using 1:8:9 with errorbars title "FACEMC-LinLog",\
     "experimental_results.txt" using 1:2:3 with errorbars title "Hanson"
>>>>>>> 3dad22a8e60128d4f4433978748ee46d369e8ef5
unset multiplot
