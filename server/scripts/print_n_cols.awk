#!/usr/bin/awk -f

BEGIN{OFS="\t"}
{for (i=C; i<=N; i++) printf("%s%s", $i, i==N?ORS:OFS)}
