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

if [ ! -d data/fademind_add_risk/ ]
then
	mkdir -p 'data/fademind_add_risk/'
fi
${WGET} wget -qO- "https://github.com/FadeMind/hosts.extras/raw/master/add.Risk/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/fademind_add_risk/domain.list
printf "Imported FadeMind add.Risk\n"

if [ ! -d data/fademind_add_spam/ ]
then
	mkdir -p 'data/fademind_add_spam/'
	touch 'data/fademind_add_spam/.gitkeep'
fi

${WGET} -qO- "https://github.com/FadeMind/hosts.extras/raw/master/add.Spam/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/fademind_add_spam/domain.list
printf "Imported FadeMind add.Spam\n"

if [ ! -d data/fademind_antipopads/ ]
then
	mkdir -p 'data/fademind_antipopads/'
	touch 'data/fademind_antipopads/.gitkeep'
fi

${WGET} -qO- "https://github.com/FadeMind/hosts.extras/raw/master/antipopads/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/fademind_antipopads/domain.list
printf "Imported FadeMind AntiPopAds\n"

if [ ! -d data/fademind_blocklists-facebook/ ]
then
	mkdir -p 'data/fademind_blocklists-facebook/'
	touch 'data/fademind_blocklists-facebook/.gitkeep'
fi

${WGET} -qO- "https://github.com/FadeMind/hosts.extras/raw/master/blocklists-facebook/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/fademind_blocklists-facebook/domain.list
printf "Imported FadeMind blocklists-facebook\n"

if [ ! -d data/CoinBlockerLists/ ]
then
	mkdir -p 'data/CoinBlockerLists/'
	touch 'data/CoinBlockerLists/.gitkeep'
fi

${WGET} -qO- "https://gitlab.com/ZeroDot1/CoinBlockerLists/raw/master/list.txt" | sort -u > data/CoinBlockerLists/domain.list
printf "Imported CoinBlockerLists\n"


if [ ! -d data/xorcan/ ]
then
	mkdir -p 'data/xorcan/'
	touch 'data/xorcan/.gitkeep'
	${WGET} 'https://raw.githubusercontent.com/xorcan/hosts/master/README-EN.md' -o data/xorcan/README.md
	${WGET} 'https://github.com/xorcan/hosts/blob/master/LICENSE' -o data/xorcan/LICENSE
fi

${WGET} -qO- "https://github.com/xorcan/hosts/raw/master/xhosts.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",$2) | "sort -u -i" }' > data/xorcan/domain.list
printf "Imported FadeMind blocklists-facebook\n"
