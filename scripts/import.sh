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

${WGET} -qO- 'https://ransomwaretracker.abuse.ch/feeds/csv/' | awk -F, '/^#/{ next }; { if ( $4 ~ /[a-z]/ ) printf("%s\n",tolower($4)) }' | sed -e 's/"//g' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort -u > data/abuse.ch/ransomware/domain.list
printf "Imported abuse.ch\n"

# Full featured RPZ list availble from
# https://sslbl.abuse.ch/blacklist/sslbl.rpz
${WGET} -qO- "https://sslbl.abuse.ch/blacklist/sslipblacklist.txt" | tr -d '\015' | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sed 's/ \;.*$//' | awk -F "[/.]" '{  printf("32.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n32.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$4,$3,$2,$1,$4,$3,$2,$1) }' > data/abuse.ch/sslipblacklist/ipv4.in-addr.arpa
${WGET} -qO- "https://sslbl.abuse.ch/blacklist/sslipblacklist.txt" | tr -d '\015' | grep -v "#" | cut -d " " -f 1 > data/abuse.ch/sslipblacklist/ip4.list
printf "Imported abuse.ch\n"

${WGET} -qO- 'https://urlhaus.abuse.ch/downloads/rpz/' | awk '/^;/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' > data/abuse.ch/urlhaus/domain.list
printf "Imported urlhaus.abuse.ch\n"

${WGET} -qO- 'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts' | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/StevenBlack/domain.list
printf "Imported StevenBlack\n"

${WGET} -qO- 'http://someonewhocares.org/hosts/hosts' | grep -v '#' | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/someonewhocares/domain.list
printf "Imported someonewhocares\n"

${WGET} wget -qO- "https://github.com/FadeMind/hosts.extras/raw/master/add.Risk/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/fademind_add_risk/domain.list
printf "Imported FadeMind add.Risk\n"

${WGET} -qO- "https://github.com/FadeMind/hosts.extras/raw/master/add.Spam/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/fademind_add_spam/domain.list
printf "Imported FadeMind add.Spam\n"

${WGET} -qO- "https://github.com/FadeMind/hosts.extras/raw/master/antipopads/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/fademind_antipopads/domain.list
printf "Imported FadeMind AntiPopAds\n"

${WGET} -qO- "https://github.com/FadeMind/hosts.extras/raw/master/blocklists-facebook/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/fademind_blocklists-facebook/domain.list
printf "Imported FadeMind blocklists-facebook\n"

${WGET} -qO- "https://gitlab.com/ZeroDot1/CoinBlockerLists/raw/master/list.txt" | sort -u | uniq -u | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/CoinBlockerLists/domain.list
printf "Imported CoinBlockerLists\n"

${WGET} -qO- "https://github.com/xorcan/hosts/raw/master/xhosts.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/xorcan/domain.list
printf "Imported xorcan\n"

${WGET} -qO- "http://winhelp2002.mvps.org/hosts.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/mvps/domain.list
printf "Imported mvps\n"

${WGET} -qO- "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/windowsspyblocker/domain.list
printf "Imported WindowsSpyBlocker\n"

${WGET} -qO- "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/extra.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/windowsspyblocker_extra/domain.list
printf "Imported WindowsSpyBlocker Extra\n"

${WGET} -qO- "https://raw.githubusercontent.com/jawz101/MobileAdTrackers/master/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/mobileadtrackers/domain.list
printf "Imported jawz101 MobileAdTrackers\n"

${WGET} -qO- "https://www.squidblacklist.org/downloads/dg-malicious.acl" | awk '/^#/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/dg-malicious/domain.list
printf "Imported dg-malicious\n"

${WGET} -qO- "https://www.squidblacklist.org/downloads/dg-ads.acl" | awk '/^#/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/dg-ads/domain.list
printf "Imported dg-ads\n"

${WGET} -qO- "https://www.malwaredomainlist.com/hostslist/hosts.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/malwaredomainlist/domain.list
printf "Imported malwaredomainlist\n"

${WGET} -q "https://www.joewein.net/dl/bl/dom-bl-base.txt" -O data/joewein/domain.list
printf "Imported joewein\n"

${WGET} -qO- "https://www.dshield.org/feeds/suspiciousdomains_Low.txt" | awk '/^#/{ next }; /^Site/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/suspiciousdomains_low/domain.list
printf "Imported suspiciousdomains Low\n"

${WGET} -qO- "https://www.dshield.org/feeds/suspiciousdomains_Medium.txt" | awk '/^#/{ next }; /^Site/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/suspiciousdomains_medium/domain.list
printf "Imported suspiciousdomains Medium\n"

${WGET} -qO- "https://www.dshield.org/feeds/suspiciousdomains_High.txt" | awk '/^#/{ next }; /^Site/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/suspiciousdomains_high/domain.list
printf "Imported suspiciousdomains High\n"


${WGET} -qO- "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt" | awk '/^#/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/notrack/blocklists/domain.list
printf "Imported notrack-blocklist\n"

${WGET} -qO- "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt" | awk '/^#/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/notrack/malware/domain.list
printf "Imported notrack-malware\n"

printf "Downloading hosts-file.net....\n"
	${WGET} -qO- "https://hosts-file.net/ad_servers.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/hphosts_ad_servers/domain.list
	${WGET} -qO- "https://hosts-file.net/emd.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/hphosts_emd/domain.list
	${WGET} -qO- "https://hosts-file.net/exp.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/hphosts_exp/domain.list
	${WGET} -qO- "https://hosts-file.net/fsa.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/hphosts_fsa/domain.list
	${WGET} -qO- "https://hosts-file.net/grm.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/hphosts_grm/domain.list
	${WGET} -qO- "https://hosts-file.net/hjk.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/hphosts_hjk/domain.list
	${WGET} -qO- "https://hosts-file.net/mmt.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/hphosts_mmt/domain.list
	${WGET} -qO- "https://hosts-file.net/psh.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/hphosts_psh/domain.list
	${WGET} -qO- "https://hosts-file.net/pup.txt" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/hphosts_pup/domain.list
printf "PUuh.. done importing hosts-file.net....\n"

${WGET} -qO- https://mirror.cedia.org.ec/malwaredomains/immortal_domains.txt | awk '/^#/{ next }; /^Site/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/cedia/domain.list
printf "Imported cedia\n"

${WGET} -qO- https://mirror1.malwaredomains.com/files/justdomains | grep -ivE '^(#|$)' | sort | uniq -u > data/malwaredomains/domain.list
printf "mirror1.malwaredomains.com\n"

${WGET} -qO- "https://blocklist.site/app/dl/ads" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u > data/blocklist_ads/domain.list
${WGET} -qO- "https://blocklist.site/app/dl/fraud" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u > data/blocklist_fraud/domain.list
${WGET} -qO- "https://blocklist.site/app/dl/malware" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u > data/blocklist_malware/domain.list
${WGET} -qO- "https://blocklist.site/app/dl/phishing" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u > data/blocklist_phising/domain.list
${WGET} -qO- "https://blocklist.site/app/dl/ransomware" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u > data/blocklist_ransomeware/domain.list
${WGET} -qO- "https://blocklist.site/app/dl/redirect" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u > data/blocklist_redirect/domain.list
${WGET} -qO- "https://blocklist.site/app/dl/scam" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u > data/blocklist_scam/domain.list
${WGET} -qO- "https://blocklist.site/app/dl/spam" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u > data/blocklist_spam/domain.list
${WGET} -qO- "https://blocklist.site/app/dl/tracking" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u > data/blocklist_tracking/domain.list

${WGET} -qO- "https://gist.githubusercontent.com/BBcan177/b6df57cef74e28d90acf1eec93d62d3b/raw/f0996cf5248657ada2adb396f3636be8716b99eb/MS-4" | awk '/^#/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/BBcan177_MS-4/domain.list
${WGET} -qO- "https://gist.githubusercontent.com/BBcan177/4a8bf37c131be4803cb2/raw/343ff780e15205b4dd0de37c86af34cfb26b2fbe/MS-2" | awk '/^#/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/BBcan177_MS-2/domain.list

${WGET} -qO- "https://phishing.army/download/phishing_army_blocklist_extended.txt"| awk '/^#/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/phishing_army_blocklist_extended/domain.list

${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts" | awk '/^#/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/badd_boyz_hosts/domain.list
${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/hacked-domains.list" | awk '/^#/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/the-big-list-of-hacked-malware-web-sites/domain.list

${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/phishing-domains-ACTIVE.txt" | awk '/^#/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/mitchellkrogza/phishing.database/domain.list
${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/phishing-IPs-ACTIVE.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | awk -F "." '{  printf("32.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n32.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$4,$3,$2,$1,$4,$3,$2,$1) }' > data/mitchellkrogza/phishing.database/ipv4.in-addr.arpa
${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/phishing-IPs-ACTIVE.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > data/mitchellkrogza/phishing.database/ipv4.list
${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/LICENSE.md" > data/mitchellkrogza/phishing.database/LICENSE.md
${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/README.md" > data/mitchellkrogza/phishing.database/README.md


${WGET} -qO- "https://osint.bambenekconsulting.com/feeds/c2-dommasterlist.txt" |  awk -F "," '!/^($|#)/{ print $1 | "sort -i | uniq -u -i " }' > data/bambenekconsulting/domain.list
${WGET} -q "https://osint.bambenekconsulting.com/feeds/license.txt" -O data/bambenekconsulting/LICENSE.md

# spamhaus.org
# drop
${WGET} -qO- "https://www.spamhaus.org/drop/drop.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sed 's/ \;.*$//' | awk -F "[/.]" '{  printf("%s.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n%s.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$5,$4,$3,$2,$1,$5,$4,$3,$2,$1) }' > data/spamhaus/drop/ipv4.in-addr.arpa

# Edrop
${WGET} -qO- "https://www.spamhaus.org/drop/edrop.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sed 's/ \;.*$//' | awk -F "[/.]" '{  printf("%s.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n%s.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$5,$4,$3,$2,$1,$5,$4,$3,$2,$1) }' > data/spamhaus/edrop/ipv4.in-addr.arpa

printf "Importing Disconnect ad-servers"
mkdir -p data/disconnect-me/
${WGET} -qO- "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' > data/disconnect-me/domain.list
