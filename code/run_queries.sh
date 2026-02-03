#!/bin/bash

cd ../sql
rm ./Q*.txt
for d in ./Q*.sql ; do
    mysql -h 10.0.0.5 -u ntua -t -p'mariadb_ntua2004' ntua < "$d" > "${d%.sql}_out.txt"
done