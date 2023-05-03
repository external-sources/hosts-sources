#!/usr/bin/env bash

git_dir="$(git rev-parse --show-toplevel)"

# This script is intended to list all active lists from the data/
# directory for easier imports from external sources....
# Happy havesting :)

truncate -s 0 "${git_dir}/sources.list"

for lists in `find data/ -type f -name domain.list`
do
	printf "https://0xacab.org/my-privacy-dns/import-external-sources/hosts-sources/-/raw/master/$lists\n" | sort -u -f >> "${git_dir}/sources.list"
done

echo -e "\n\nThe script ${0}\nExited with error code ${?}\n\n"
