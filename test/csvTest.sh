#!/bin/bash
#
# Copyright (c) 2024.  My Privacy DNS
#
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU Affero General Public License as
#     published by the Free Software Foundation, either version 3 of the
#     License, or (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU Affero General Public License for more details.
#
#     You should have received a copy of the GNU Affero General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

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
