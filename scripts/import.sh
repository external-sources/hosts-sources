#!/usr/bin/env bash

# The purpose of this script is to import various external hosts files into lists
# that only contains domain.tld, for easier working with the lists to our RPZ files

# Exit on any errors

set -eu

# Set the right path for "executables"
git_dir="$(git rev-parse --show-toplevel)"

WGET="$(command -v wget)"
# CURL="$(command -v curl)"
# PYTHON="$(command -v python3)"

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

# Clean up old data dir to make a fresh a data dir as possible
rm -fr "${git_dir}/data/"

# Next let's Download some external sources, so we don't need to keep
# downloading them, and save them some bandwidth

#mkdir -p "${git_dir}/data/yoyo/"
#fetch 'https://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&showintro=0&mimetype=plaintext' | grep -Ev '#' | tr , '\n' | sort -u >"data/yoyo/domain.csv"
#echo "Imported yoyo (Peter Lowe)"

# Full featured RPZ list available from
# https://sslbl.abuse.ch/blacklist/sslbl.rpz
mkdir -p "${git_dir}/data/abuse.ch/sslipblacklist/"
fetch "https://sslbl.abuse.ch/blacklist/sslipblacklist.txt" | tr -d '\015' | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sed 's/ \;.*$//' | awk -F "[/.]" '{  printf("32.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n32.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$4,$3,$2,$1,$4,$3,$2,$1) }' >"data/abuse.ch/sslipblacklist/ipv4.in-addr.arpa"
fetch "https://sslbl.abuse.ch/blacklist/sslipblacklist.txt" | tr -d '\015' | grep -v "#" | cut -d " " -f 1 >"data/abuse.ch/sslipblacklist/ip4.csv"
echo "Imported abuse.ch"

mkdir -p "${git_dir}/data/abuse.ch/urlhaus/"
${WGET} -qO- 'https://urlhaus.abuse.ch/downloads/rpz/' | awk '/^;/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' >"data/abuse.ch/urlhaus/domain.csv"
echo "Imported urlhaus.abuse.ch"

# Moved to url-to-downloads.php
#mkdir -p "${git_dir}/data/notrack/blocklists/"
#c "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/notrack/blocklists/domain.csv"
#echo "Imported notrack-blocklist"
#
#mkdir -p "${git_dir}/data/notrack/malware/"
#c "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/notrack/malware/domain.csv"
#echo "Imported notrack-malware"

# spamhaus.org
# drop
mkdir -p "${git_dir}/data/spamhaus/drop/"
${WGET} -qO- "https://www.spamhaus.org/drop/drop.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sed 's/ \;.*$//' | awk -F "[/.]" '{  printf("%s.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n%s.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$5,$4,$3,$2,$1,$5,$4,$3,$2,$1) }' >"data/spamhaus/drop/ipv4.in-addr.arpa"
echo "Imported Drop spamhaus.org"

# coinblocker
# mkdir -p "${git_dir}/data/spamhaustech/coinblocker/"
# drill axfr coinblocker.srv @35.156.219.71 -p 53 | grep -vE "^(;|$)|(SOA|NS)" | sed -e 's/\.coinblocker\.srv\.[[:blank:]].*$//g' >"data/spamhaustech/coinblocker/domain.csv"
# echo "Imported coinblocker .dtq"

# We need to avoid the IP hosts provided by openfish as they can't be used with hosts files'
 mkdir -p "${git_dir}/data/openfish/"
 fetch "https://openphish.com/feed.txt" | awk -F "/" '!/^($|#)/{ print $3 | "sort -u | uniq -u -i " }' | grep -Ev "\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\b" >"data/openfish/domain.csv"
 fetch "https://openphish.com/feed.txt" | awk -F "/" '!/^($|#)/{ print $3 | "sort -u | uniq -u -i " }' | grep -E "\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\b" | awk -F "." '{  printf("32.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n32.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$4,$3,$2,$1,$4,$3,$2,$1) }' >"data/openfish/ipv4.in-addr.arpa"
 echo "Imported openfish.com"

# START @mitchellkrogza's many lists
 echo "@mitchellkrogza's lists: START"

# Perlscript as by https://unix.stackexchange.com/a/745455
 echo ""
 echo "Importing Phishing Database"
 mkdir -p "${git_dir}/data/phishing_database/"
 wget "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/ALL-phishing-links.txt" -qO- |
     perl -lne 's!^(?:ftp|https?)://!!;
   s![/?#].*!!;
   s!^.*\@!!;
   s!:\d+\z!!a;
   s![.]$!!;
   next if /^[\d.]+\z/a;
   if (/[^._\-[:^punct:]]/) { warn "skipping $_ ...\n";
   next } print lc $_' - |
     sort -u |
     uniq -i |
     python3 "${git_dir}/scripts/domain-sort.py" >"${git_dir}/data/phishing_database/ALL-phishing-links.csv"

# | sort -u | python3 "${git_dir}/scripts/domain-sort.py" >"data/phishing_database/ALL-phishing-links.txt"

 echo "Done importing Phishing Database"
 echo ""

# mkdir -p "${git_dir}/data/mitchellkrogza/phishing.database/"
# echo ""
# echo "Phishing.Database"
# echo ""
# ${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/phishing-domains-ACTIVE.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/mitchellkrogza/phishing.database/domain.csv"
# ${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/phishing-IPs-ACTIVE.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | awk -F "." '{  printf("32.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n32.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$4,$3,$2,$1,$4,$3,$2,$1) }' >"data/mitchellkrogza/phishing.database/ipv4.in-addr.arpa"
# ${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/phishing-IPs-ACTIVE.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" >"data/mitchellkrogza/phishing.database/ipv4.csv"
# ${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/LICENSE.md" -O "data/mitchellkrogza/phishing.database/LICENSE.md"
# ${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/README.md" -O "data/mitchellkrogza/phishing.database/README.md"

 # As I have no idea or couldn't find any RFC telling me that an IPv4 is a valid
 # domain name. It is necessary to remove them from "Domain"? list :smirk: :devil:

# END @mitchellkrogza's many lists
 echo "@mitchellkrogza's lists: END"


echo ""
echo ""
echo "The script ${0}"
# shellcheck disable=SC2320
echo -e "Exited with error code ${?}\n\n"

# git add .

# tag=$(date +'day: %j of year %Y %H:%M:%S')

# git commit -a -m "New release ${tag}" && git push

