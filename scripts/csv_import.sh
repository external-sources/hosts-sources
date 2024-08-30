#!/usr/bin/env bash

# Copyright (C) 2024 My Privacy DNS
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Exit on any errors

set -eu

# Set the right path for "executables"
git_dir="$(git rev-parse --show-toplevel)"

# Keep the `function` to avoid possible conflicts on UNIX systems
function fetch() {
    "$(command -v curl)" \
        --show-error \
        --location \
        --ignore-content-length \
        --silent \
        --retry 5 \
        --retry-delay 2 \
        --url "${1}"
}

cd "${git_dir}"
targetDir="${git_dir}/data" # No ending slash

# Clean out old data
rm -fr "${git_dir}/test/data/" "${targetDir}"

# Start the import process
while IFS="," read -r name type url; do
    echo "importing $name"

    # shellcheck disable=SC2174
    mkdir -p --mode=775 "${targetDir}"
    # ls -lha "${targetDir}"

    if [ "$type" == 'rfc952' ]; then
        fetch "$url" | awk '/localhost/{next}; /^(#|$)/{ next }; \
            { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' > "${targetDir}/$name.csv"

    elif [ "$type" == 'domain' ]; then
        fetch "$url" | awk '/localhost/{next}; /^(#|$)/{ next }; \
            { printf("%s\n",tolower($1)) | "sort -i | uniq -u -i " }' \
            > "${targetDir}/$name.csv"
    fi
    echo "imported $name"
    echo ""
done < <(tail -n +2 scripts/source.csv)
