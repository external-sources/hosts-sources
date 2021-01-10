#!/usr/bin/env bash

# The perpose of this script is to import various eternal hosts files into lists
# that contail only domain.tld for easier working with the lists to our RPZ files

# Exit on any errors

set -e

# Set the right path for "executebles"
WGET=`(command -v wget)`
CURL=`(command -v curl)`
PYTHON=`(command -v python3)`

# Next let's Download some external sources, so we don't need to keep
# downloading them, and save them some bandwidth

mkdir -p "data/yoyo.org/"
${WGET} -qO- 'https://pgl.yoyo.org/adservers/serverlist.php?hostformat=one-line&showintro=0&mimetype=plaintext' | egrep -v '#' | tr , '\n' | sort -u > "data/yoyo.org/domain.list"
printf "Imported yoyo\n"

# Ransomware Tracker has been discontinued on Dec 8th, 2019
#${WGET} -qO- 'https://ransomwaretracker.abuse.ch/feeds/csv/' | awk -F, '/^(#|$)/{ next }; { if ( $4 ~ /[a-z]/ ) printf("%s\n",tolower($4)) }' | sed -e 's/"//g' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort -u > data/abuse.ch/ransomware/domain.list
#printf "Imported abuse.ch\n"

# Full featured RPZ list availble from
# https://sslbl.abuse.ch/blacklist/sslbl.rpz
mkdir -p "data/abuse.ch/sslipblacklist/"
${WGET} -qO- "https://sslbl.abuse.ch/blacklist/sslipblacklist.txt" | tr -d '\015' | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sed 's/ \;.*$//' | awk -F "[/.]" '{  printf("32.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n32.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$4,$3,$2,$1,$4,$3,$2,$1) }' > "data/abuse.ch/sslipblacklist/ipv4.in-addr.arpa"
${WGET} -qO- "https://sslbl.abuse.ch/blacklist/sslipblacklist.txt" | tr -d '\015' | grep -v "#" | cut -d " " -f 1 > "data/abuse.ch/sslipblacklist/ip4.list"
printf "Imported abuse.ch\n"

mkdir -p "data/abuse.ch/urlhaus/"
${WGET} -qO- 'https://urlhaus.abuse.ch/downloads/rpz/' | awk '/^;/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' > "data/abuse.ch/urlhaus/domain.list"
printf "Imported urlhaus.abuse.ch\n"

mkdir -p "data/someonewhocares/"
${WGET} -qO- 'http://someonewhocares.org/hosts/hosts' | grep -v '#' | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/someonewhocares/domain.list"
printf "Imported someonewhocares\n"

mkdir -p "data/fademind_add_risk/"
${WGET} wget -qO- "https://github.com/FadeMind/hosts.extras/raw/master/add.Risk/hosts" | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/fademind_add_risk/domain.list"
printf "Imported FadeMind add.Risk\n"

mkdir -p "data/fademind_add_spam/"
${WGET} -qO- "https://github.com/FadeMind/hosts.extras/raw/master/add.Spam/hosts" | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/fademind_add_spam/domain.list"
printf "Imported FadeMind add.Spam\n"

mkdir -p "data/fademind_antipopads/"
${WGET} -qO- "https://github.com/FadeMind/hosts.extras/raw/master/antipopads/hosts" | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/fademind_antipopads/domain.list"
printf "Imported FadeMind AntiPopAds\n"

mkdir -p "data/fademind_blocklists-facebook/"
${WGET} -qO- "https://github.com/FadeMind/hosts.extras/raw/master/blocklists-facebook/hosts" | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/fademind_blocklists-facebook/domain.list"
printf "Imported FadeMind blocklists-facebook\n"

mkdir -p "data/CoinBlockerLists/"
${WGET} -qO- "https://zerodot1.gitlab.io/CoinBlockerLists/list.txt" | sort -u | uniq -u | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/CoinBlockerLists/domain.list"
printf "Imported CoinBlockerLists\n"

mkdir -p "data/xorcan/"
${WGET} -qO- "https://raw.githubusercontent.com/xorcan/hosts/master/xhosts.txt" | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/xorcan/domain.list"
${WGET} -q "https://raw.githubusercontent.com/xorcan/hosts/master/README-EN.md" -O "data/xorcan/README-EN.md"
${WGET} -q "https://raw.githubusercontent.com/xorcan/hosts/master/README.md" -O "data/xorcan/README.md"
${WGET} -q "https://raw.githubusercontent.com/xorcan/hosts/master/LICENSE" -O "data/xorcan/LICENSE"
printf "Imported xorcan\n"

mkdir -p "data/mvps/"
${WGET} -qO- "http://winhelp2002.mvps.org/hosts.txt" | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/mvps/domain.list"
printf "Imported mvps\n"

mkdir -p "data/windowsspyblocker/"
${WGET} -qO- "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt" | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/windowsspyblocker/domain.list"
printf "Imported WindowsSpyBlocker\n"

mkdir -p "data/windowsspyblocker_extra/"
${WGET} -qO- "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/extra.txt" | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/windowsspyblocker_extra/domain.list"
printf "Imported WindowsSpyBlocker Extra\n"

# MobileAdTrackers have closed and moved to https://github.com/AdAway/adaway.github.io/
#${WGET} -qO- "https://raw.githubusercontent.com/jawz101/MobileAdTrackers/master/hosts" | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > data/mobileadtrackers/domain.list
#printf "Imported jawz101 MobileAdTrackers\n"
rm -fr "data/mobileadtrackers/"

mkdir -p "data/adaway/domain"
${WGET} -qO- "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt"  | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' > "data/adaway/domain.list"
${WGET} -qO- "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/README.md" -O "data/adaway/README.md"
${WGET} -qO- "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/LICENSE.md" -O "data/adaway/LICENSE.md"
printf "Imported @jawz101 adaway.github.io\n"

mkdir -p "data/dg-malicious/"
${WGET} -qO- "https://www.squidblacklist.org/downloads/dg-malicious.acl" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/dg-malicious/domain.list"
printf "Imported dg-malicious\n"

mkdir -p "data/dg-ads/"
${WGET} -qO- "https://www.squidblacklist.org/downloads/dg-ads.acl" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/dg-ads/domain.list"
printf "Imported dg-ads\n"

mkdir -p "data/malwaredomainlist/"
${WGET} -qO- "https://www.malwaredomainlist.com/hostslist/hosts.txt" | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/malwaredomainlist/domain.list"
printf "Imported malwaredomainlist\n"

mkdir -p "data/joewein/"
${WGET} -qO- "https://www.joewein.net/dl/bl/dom-bl-base.txt" | grep -Ev '\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\b' | grep -Ev '(\%a\;419|\{|^$)' | sed 's/\;.*//' > "data/joewein/domain.list"
printf "Imported joewein\n"

mkdir -p "data/suspiciousdomains_low/"
${WGET} -qO- "https://www.dshield.org/feeds/suspiciousdomains_Low.txt" | awk '/^(#|$)/{ next }; /^Site/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/suspiciousdomains_low/domain.list"
printf "Imported suspiciousdomains Low\n"

mkdir -p "data/suspiciousdomains_medium/"
${WGET} -qO- "https://www.dshield.org/feeds/suspiciousdomains_Medium.txt" | awk '/^(#|$)/{ next }; /^Site/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/suspiciousdomains_medium/domain.list"
printf "Imported suspiciousdomains Medium\n"

mkdir -p "data/suspiciousdomains_high/"
${WGET} -qO- "https://www.dshield.org/feeds/suspiciousdomains_High.txt" | awk '/^(#|$)/{ next }; /^Site/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/suspiciousdomains_high/domain.list"
printf "Imported suspiciousdomains High\n"

mkdir -p "data/notrack/blocklists/"
${WGET} -qO- "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/notrack/blocklists/domain.list"
printf "Imported notrack-blocklist\n"

mkdir -p "data/notrack/malware/"
${WGET} -qO- "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/notrack/malware/domain.list"
printf "Imported notrack-malware\n"

# https://bitbucket.org/expiredsources/hosts-file.net/src/master/
printf "Downloading Active hosts-file.net....\n"

dir_array=(ad_servers emd exp fsa grm hjk mmt psh pup)
hpUrl="https://bitbucket.org/expiredsources/hosts-file.net/raw/master/active/"

for d in "${dir_array[@]}"
do
	mkdir -p "data/hphosts/${d}"
	echo -e "\t\nImporting ${d}\n"
	${WGET} -qO- "${hpUrl}/${d}.txt" | grep -vE '^(#|$)' > "data/hphosts/${d}/domain.list"
done

# For protecting the future devs we unset variables
dir_array=""
hpUrl=""

printf "Puuh.. done importing Active hosts-file.net....\n"

${WGET} -qO- https://mirror.cedia.org.ec/malwaredomains/immortal_domains.txt | awk '/^(#|$)/{ next }; /^Site/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/cedia/domain.list"
printf "Imported cedia\n"

${WGET} -qO- https://mirror1.malwaredomains.com/files/justdomains | grep -ivE '^(#|$)' | sort | uniq -u > data/malwaredomains/domain.list
printf "Imported mirror1.malwaredomains.com\n"

# blocklistproject CNAME blocklist-site
# This url is bullshit, trying to bump his own domain. Bullshit url="bsUrl="https://blocklist.site/app/dl/""
bsDir_array=(abuse ads crypto drugs facebook fraud gambling malware phishing piracy porn ransomware redirect scam torrent tracking youtube)
bsUrl="https://raw.githubusercontent.com/blocklistproject/Lists/master/"

for bs in "${bsDir_array[@]}"
do
	mkdir -p "data/blocklist_${bs}"
	echo -e "\t\nImporting ${bs}\n"
	${WGET} -qO- "${bsUrl}${bs}.txt" | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u > "data/blocklist_${bs}/domain.list"
done

# Unset variables
bsDir_array=""
bsUrl=""

printf "Imported blocklist.site\n"

${WGET} -qO- "https://gist.githubusercontent.com/BBcan177/b6df57cef74e28d90acf1eec93d62d3b/raw/f0996cf5248657ada2adb396f3636be8716b99eb/MS-4" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/BBcan177_MS-4/domain.list"
${WGET} -qO- "https://gist.githubusercontent.com/BBcan177/4a8bf37c131be4803cb2/raw/343ff780e15205b4dd0de37c86af34cfb26b2fbe/MS-2" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/BBcan177_MS-2/domain.list"
printf "Imported BBcan177\n"

${WGET} -qO- "https://phishing.army/download/phishing_army_blocklist_extended.txt"| awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/phishing_army_blocklist_extended/domain.list"
printf "Imported phishing.army\n"

# START @mitchellkrogza's many lists
printf "START importing @mitchellkrogza's many lists\n"

mkdir -p "data/mitchellkrogza/badd_boyz_hosts/"
${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts" | awk '/^(#|$)/{ next }; { if ( $2 ~ /[a-z]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/mitchellkrogza/badd_boyz_hosts/domain.list"
${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/README.md" -O "data/mitchellkrogza/badd_boyz_hosts/README.md"
${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/LICENSE.md" -O "data/mitchellkrogza/badd_boyz_hosts/LICENSE.md"

mkdir -p "data/mitchellkrogza/the-big-list-of-hacked-malware-web-sites/"
${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/hacked-domains.list" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/mitchellkrogza/the-big-list-of-hacked-malware-web-sites/domain.list"
${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/README.md" -O "data/mitchellkrogza/the-big-list-of-hacked-malware-web-sites/README.md"
${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/LICENSE.md" -O "data/mitchellkrogza/the-big-list-of-hacked-malware-web-sites/LICENSE.md"

mkdir -p "data/mitchellkrogza/phishing.database/"
${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/phishing-domains-ACTIVE.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' > "data/mitchellkrogza/phishing.database/domain.list"
${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/phishing-IPs-ACTIVE.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | awk -F "." '{  printf("32.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n32.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$4,$3,$2,$1,$4,$3,$2,$1) }' > "data/mitchellkrogza/phishing.database/ipv4.in-addr.arpa"
${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/phishing-IPs-ACTIVE.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > "data/mitchellkrogza/phishing.database/ipv4.list"
${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/LICENSE.md" -O "data/mitchellkrogza/phishing.database/LICENSE.md"
${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/README.md" -O "data/mitchellkrogza/phishing.database/README.md"

# As I have no idea or couln't find any RFC telling me that an IPv4 is a valid
# domain name. It is nessesary to remove them from "Domain"? list

mkdir -p "data/mitchellkrogza/Ultimate.Hosts.Blacklist/"
${WGET} -qO- "https://hosts.ubuntu101.co.za/domains.list" | grep -vE "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$" > "data/mitchellkrogza/Ultimate.Hosts.Blacklist/domain.list"
${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/Ultimate.Hosts.Blacklist/master/README.md" -O "data/mitchellkrogza/Ultimate.Hosts.Blacklist/README.md"
${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/Ultimate.Hosts.Blacklist/master/LICENSE.md" -O "data/mitchellkrogza/Ultimate.Hosts.Blacklist/LICENSE.md"
printf "Done importing @mitchellkrogza's many lists\n"
# END @mitchellkrogza's many lists

mkdir -p "data/bambenekconsulting/"
${WGET} -qO- "https://osint.bambenekconsulting.com/feeds/c2-dommasterlist.txt" |  awk -F "," '!/^($|#)/{ print $1 | "sort -i | uniq -u -i " }' > "data/bambenekconsulting/domain.list"
${WGET} -q "https://osint.bambenekconsulting.com/feeds/license.txt" -O "data/bambenekconsulting/LICENSE.md"
printf "Imported bambenekconsulting.com\n"

# spamhaus.org
# drop
mkdir -p "data/spamhaus/drop/"
${WGET} -qO- "https://www.spamhaus.org/drop/drop.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sed 's/ \;.*$//' | awk -F "[/.]" '{  printf("%s.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n%s.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$5,$4,$3,$2,$1,$5,$4,$3,$2,$1) }' > "data/spamhaus/drop/ipv4.in-addr.arpa"
printf "Imported Drop spamhaus.org\n"

# implanting .dtq from https://www.mypdns.org/w/ixfrdist/#532

# Edrop
${WGET} -qO- "https://www.spamhaus.org/drop/edrop.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sed 's/ \;.*$//' | awk -F "[/.]" '{  printf("%s.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n%s.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$5,$4,$3,$2,$1,$5,$4,$3,$2,$1) }' > "data/spamhaus/edrop/ipv4.in-addr.arpa"
printf "Imported eDrop spamhaus.org\n"

# coinblocker
mkdir -p "data/spamhaustech/coinblocker/"
drill axfr coinblocker.srv @35.156.219.71 -p 53 | grep -vE "^(;|$)|(SOA|NS)" | sed -e 's/\.coinblocker\.srv\.[[:blank:]].*$//g' > "data/spamhaustech/coinblocker/domain.list"
printf "Imported coinblocker .dtq\n"

printf "Importing Porn.hosts.srv"
mkdir -p "data/spamhaustech/porn_host_srv/"
drill axfr @35.156.219.71 -p 53 porn.host.srv | grep -vE "^(;|$|\*)|(SOA|NS)" | sed -e 's/\.porn\.host\.srv\.[[:blank:]].*$//g' > "data/spamhaustech/porn_host_srv/domain.list"
printf "Imported Porn.hosts.srv from ..dtq\n"

# Disconnect ad-servers
mkdir -p data/disconnect-me/
${WGET} -qO- "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' > "data/disconnect-me/domain.list"
printf "Imported simple disconnect.me\n"

printf "Importing openfish.com\n"
# We need to avoid the IP hosts provided by openfish as they can't be used with hosts files'
mkdir -p "data/openfish/"
${WGET} -qO- "https://openphish.com/feed.txt" | awk -F "/" '!/^($|#)/{ print $3 | "sort -u | uniq -u -i " }' | grep -Ev "\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\b" > "data/openfish/domain.list"
${WGET} -qO- "https://openphish.com/feed.txt" | awk -F "/" '!/^($|#)/{ print $3 | "sort -u | uniq -u -i " }' | grep -E "\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\b" | awk -F "." '{  printf("32.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n32.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$4,$3,$2,$1,$4,$3,$2,$1) }' > "data/openfish/ipv4.in-addr.arpa"

echo -e "\n\nThe script ${0}\nExited with error code ${?}\n\n"
