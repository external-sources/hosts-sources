#!/usr/bin/env bash

# The perpose of this script is to import various eternal hosts files into lists
# that contail only domain.tld for easier working with the lists to our RPZ files

# Exit on any erros

set -e

# Set the right path for "executebles"
WGET=`(which wget)`
CURL=`(which curl)`
PYTHON=`(which python3)`

# Next let's Download some external sources, so we don't need to keep
# downloading them, and save them some bandwidth


${WGET} -qO- 'https://pgl.yoyo.org/adservers/serverlist.php?hostformat=one-line&showintro=0&mimetype=plaintext' | egrep -v '#' | tr , '\n' | sort -u > data/yoyo.org/domain.list
printf "Imported yoyo\n"

${WGET} -qO- 'https://ransomwaretracker.abuse.ch/feeds/csv/' | awk -F, '/^#/{ next }; { if ( $4 ~ /[a-z]/ ) printf("%s\n",$4) }' | sed -ne 's/"//g' | sort -u > data/ransomware.abuse.ch/domain.list
printf "Imported abuse.ch\n"

${WGET} -qO- 'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts' | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/StevenBlack/domain.list
printf "Imported StevenBlack\n"

${WGET} -qO- 'http://someonewhocares.org/hosts/hosts' | grep '^127\.0\.0\.1' | cut -d' ' -f2 | grep -v '127\.0\.0\.1' | dos2unix | sort -u > data/someonewhocares/domain.list
printf "Imported someonewhocares\n"

${WGET} wget -qO- "https://github.com/FadeMind/hosts.extras/raw/master/add.Risk/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/fademind_add_risk/domain.list
printf "Imported FadeMind add.Risk\n"

${WGET} -qO- "https://github.com/FadeMind/hosts.extras/raw/master/add.Spam/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/fademind_add_spam/domain.list
printf "Imported FadeMind add.Spam\n"

${WGET} -qO- "https://github.com/FadeMind/hosts.extras/raw/master/antipopads/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/fademind_antipopads/domain.list
printf "Imported FadeMind AntiPopAds\n"

${WGET} -qO- "https://github.com/FadeMind/hosts.extras/raw/master/blocklists-facebook/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/fademind_blocklists-facebook/domain.list
printf "Imported FadeMind blocklists-facebook\n"

${WGET} -qO- "https://gitlab.com/ZeroDot1/CoinBlockerLists/raw/master/list.txt" | sort -u > data/CoinBlockerLists/domain.list
printf "Imported CoinBlockerLists\n"

${WGET} -qO- "https://github.com/xorcan/hosts/raw/master/xhosts.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/xorcan/domain.list
printf "Imported xorcan\n"

${WGET} -qO- "http://winhelp2002.mvps.org/hosts.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/mvps/domain.list
printf "Imported mvps\n"

${WGET} -qO- "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/windowsspyblocker/domain.list
printf "Imported WindowsSpyBlocker\n"

${WGET} -qO- "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/extra.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/windowsspyblocker_extra/domain.list
printf "Imported WindowsSpyBlocker Extra\n"

${WGET} -qO- 'https://urlhaus.abuse.ch/downloads/rpz/' | awk '/^;/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' > data/urlhaus/domain.list
printf "Imported urlhaus.abuse.ch\n"

${WGET} -qO- "https://raw.githubusercontent.com/jawz101/MobileAdTrackers/master/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/mobileadtrackers/domain.list
printf "Imported jawz101 MobileAdTrackers\n"

${WGET} -qO- "https://www.squidblacklist.org/downloads/dg-malicious.acl" | awk '/^#/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' > data/dg-malicious/domain.list
printf "Imported dg-malicious\n"

${WGET} -qO- "https://www.squidblacklist.org/downloads/dg-ads.acl" | awk '/^#/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' > data/dg-ads/domain.list
printf "Imported dg-ads\n"

${WGET} -qO- "https://www.malwaredomainlist.com/hostslist/hosts.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/malwaredomainlist/domain.list
printf "Imported malwaredomainlist\n"

${WGET} -q "https://www.joewein.net/dl/bl/dom-bl-base.txt" -O data/joewein/domain.list
printf "Imported joewein\n"

