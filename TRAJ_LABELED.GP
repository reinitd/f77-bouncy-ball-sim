set terminal pngcairo size 1200,800
set output 'TRAJ_LABELED.PNG'

set title "Height vs. Time"
set xlabel "Time (s)"
set ylabel "Height (m)"
set grid

set style arrow 1 nohead dashtype 2 lc rgb "black"

plot 'data.dat' using 1:3 with lines title 'Trajectory', \
     'peaks.dat' using (column(0)%2==0 ? $1 : 1/0):2:3 with labels offset 0,1 font ",10" notitle, \
     ''          using (column(0)%2!=0 ? $1 : 1/0):2:3 with labels offset 0,2 font ",10" notitle, \
     ''          using (column(0)%2==0 ? $1 : 1/0):2:(0):(0.25) with vectors arrowstyle 1 notitle, \
     ''          using (column(0)%2!=0 ? $1 : 1/0):2:(0):(0.45) with vectors arrowstyle 1 notitle
