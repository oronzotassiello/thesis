#!/usr/bin/awk -f

{sum+=$c; n++}
END{if(n > 0) printf "%.4f\n", sum/n}
