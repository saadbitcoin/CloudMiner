#! /bin/bash

if [ $# -ne 1 ] ; then
	echo "Uso: $0 <tabla> ('full' para toda la base de datos)" >&2
	exit 1
fi

mysql --user='clminer' -p'cloudminer2014' cloudminer < ./dumps/"$1"_data_bak.sql

