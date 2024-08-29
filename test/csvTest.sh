#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Exit on any errors

set -eu

# Set the right path for "executables"
git_dir="$(git rev-parse --show-toplevel)"

# source https://www.cyberciti.biz/faq/unix-linux-bash-read-comma-separated-cvsfile/
missing=false
while IFS=, read -r field1 field2
do
	if [ "$field1" == "" ]
	then
		echo "field1 is empty or no value set"
		missing=true
   	elif [ "$field2" == "" ]
	then
		echo "field2 is empty or no value set"
		missing=true
	else
		echo "$field1 and $field2"
	fi
done < input.csv
if [ $missing ]
then
	echo "WARNING: Missing values in a CSV file. Please use the proper format. Operation failed."
	exit 1
else
	echo "CSV file read successfully."
fi