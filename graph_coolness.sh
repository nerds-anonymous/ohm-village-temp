#!/bin/bash

(
	cat <<-EOF
	set grid
	set style data impulses
	
	set title "Temperature as logged in various villages and shown on http://151.218.112.31/"
	
	set xdata time
	set timefmt "%Y-%m-%d %H:%M:%S"
	set xlabel "Time"
	set format x "%m/%d %H" 
	
	set ylabel "Temp"
	set ytics 5
	
	unset tmargin 
	set bmargin 5
	
	set key on inside right top box
	set datafile separator ";"
	set terminal png giant size 1000,600
	set output "graph_coolness.png"
	EOF

	awk -F';' '
		NR==1{start=$5};

		{ name[$1]=$2 }

	END {
		printf "set xrange [ \"%s\" : \"%s\" ] noreverse nowriteback\n\n", start, $5;
		printf "plot ";

		for (v in name){
			printf "  \"< grep \\\"^"v";\\\" fetch_coolness.log\" using 5:3 title \"" name[v] "\" with lines, \\\n"
		}
	}' fetch_coolness.log;
) | gnuplot -

