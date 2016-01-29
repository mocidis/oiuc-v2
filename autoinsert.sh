#!/bin/bash
echo "start insert into oiuc.db"
for i in {1..100}; do
	`sqlite3 databases/oiuc.db "insert into ics_hotline values(\"sư 3\", \"sư đoàn 3\", \"TT TT - SCH\", \"115\", \"102,7 Mhz\", 0.5);"`
done
