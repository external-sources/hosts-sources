#!/usr/bin/env bash

git_dir="$(git rev-parse --show-toplevel)"

url="https://github.com/external-sources/hosts-sources"

# This script is intended to list all active lists from the data/
# directory for easier imports from external sources....
# Happy harvesting :)

truncate -s 0 "${git_dir}/sources.list"

# shellcheck disable=SC2044
for lists in $(find data/ -type f -name '*.csv'); do
    # shellcheck disable=SC2296
    echo -e "$url/raw/master/$lists" |
        sort -u -f >>"${git_dir}/sources.list"
done

echo -e "\n\nThe script ${0}\nExited with error code ${?}\n\n"
