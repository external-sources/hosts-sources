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

c() {
    curl --tcp-fastopen \
        --tcp-nodelay \
        --tr-encoding \
        --compressed \
        --http2 \
        --ignore-content-length \
        --silent \
        --retry 5 \
        --retry-delay 2  \
        --url "${1}"
}

cd "${git_dir}"

# Clean up old data dir to make a fresh a data dir as possible
rm -fr "${git_dir}/data/"

# Next let's Download some external sources, so we don't need to keep
# downloading them, and save them some bandwidth

# Adaway
name="adaway"
mkdir -p "${git_dir}/data/$name/"
c https://adaway.org/hosts.txt | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

# Adroit Ador Khan antipopads-re
mkdir -p "${git_dir}/data/antipopads-re/"
c https://raw.githubusercontent.com/AdroitAdorKhan/antipopads-re/master/formats/hosts.txt | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' >"${git_dir}/data/antipopads-re/domain.csv"
echo "Imported AdroitAdorKhan antipopads-re"

mkdir -p "${git_dir}/data/yoyo/"
c 'https://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&showintro=0' | grep -Ev '#' | tr , '\n' | sort -u >"data/yoyo/domain.csv"
echo "Imported yoyo (Peter Lowe)"

# Full featured RPZ list available from
# https://sslbl.abuse.ch/blacklist/sslbl.rpz
mkdir -p "${git_dir}/data/abuse.ch/sslipblacklist/"
c "https://sslbl.abuse.ch/blacklist/sslipblacklist.txt" | tr -d '\015' | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sed 's/ \;.*$//' | awk -F "[/.]" '{  printf("32.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n32.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$4,$3,$2,$1,$4,$3,$2,$1) }' >"data/abuse.ch/sslipblacklist/ipv4.in-addr.arpa"
c "https://sslbl.abuse.ch/blacklist/sslipblacklist.txt" | tr -d '\015' | grep -v "#" | cut -d " " -f 1 >"data/abuse.ch/sslipblacklist/ip4.csv"
echo "Imported abuse.ch"

mkdir -p "${git_dir}/data/anudeepND/adservers/"
echo "anudeepND"
${WGET} -qO- "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/anudeepND/adservers/domain.csv"
echo "Imported anudeepND"

mkdir -p "${git_dir}/data/abuse.ch/urlhaus/"
${WGET} -qO- 'https://urlhaus.abuse.ch/downloads/rpz/' | awk '/^;/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' >"data/abuse.ch/urlhaus/domain.csv"
echo "Imported urlhaus.abuse.ch"

mkdir -p "${git_dir}/data/someonewhocares/"
${WGET} -qO- 'https://someonewhocares.org/hosts/hosts' | grep -v '#' | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/someonewhocares/domain.csv"
printf "Imported someonewhocares\n"

# Moved to urls-to-domains.php
#mkdir -p "${git_dir}/data/fademind_add_risk/"
#${WGET} -qO- "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts" | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/fademind_add_risk/domain.csv"
#echo "Imported FadeMind add.Risk"
#
#mkdir -p "${git_dir}/data/fademind_add_spam/"
#${WGET} -qO- "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts" | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/fademind_add_spam/domain.csv"
#echo "Imported FadeMind add.Spam"
#
#mkdir -p "${git_dir}/data/fademind_antipopads/"
#${WGET} -qO- "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/antipopads-re/hosts" | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/fademind_antipopads/domain.csv"
#echo "Imported FadeMind AntiPopAds"
#
#mkdir -p "${git_dir}/data/fademind_blocklists-facebook/"
#${WGET} -qO- "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/blocklists-facebook/hosts" | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/fademind_blocklists-facebook/domain.csv"
#echo "Imported FadeMind blocklists-facebook"

 mkdir -p "${git_dir}/data/CoinBlockerLists/"
 c 'https://zerodot1.gitlab.io/CoinBlockerLists/list.txt' | sort -u | uniq -u | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/CoinBlockerLists/domain.csv"
 echo "Imported CoinBlockerLists"

mkdir -p "${git_dir}/data/mvps/"
${WGET} -qO- "https://winhelp2002.mvps.org/hosts.txt" | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/mvps/domain.csv"
echo "Imported mvps"

mkdir -p "${git_dir}/data/adaway/domain}"
${WGET} -qO- "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt" | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' >"data/adaway/domain.csv"
${WGET} -q "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/README.md" -O "data/adaway/README.md"
${WGET} -q "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/LICENSE.md" -O "data/adaway/LICENSE.md"
echo "Imported adaway.github.io"

# mkdir -p "${git_dir}/data/dg-malicious/"
# ${WGET} -qO- "https://www.squidblacklist.org/downloads/dg-malicious.acl" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/dg-malicious/domain.csv"
# echo "Imported dg-malicious"

# mkdir -p "${git_dir}/data/dg-ads/"
# ${WGET} -qO- "https://www.squidblacklist.org/downloads/dg-ads.acl" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/dg-ads/domain.csv"
# echo "Imported dg-ads"

# mkdir -p "${git_dir}/data/malwaredomainlist/"
# ${WGET} -qO- "https://www.malwaredomainlist.com/hostslist/hosts.txt" | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/malwaredomainlist/domain.csv"
# echo "Imported malwaredomainlist"

# Moved to url-to-downloads.php
#mkdir -p "${git_dir}/data/notrack/blocklists/"
#c "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/notrack/blocklists/domain.csv"
#echo "Imported notrack-blocklist"
#
#mkdir -p "${git_dir}/data/notrack/malware/"
#c "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/notrack/malware/domain.csv"
#echo "Imported notrack-malware"

# https://bitbucket.org/expiredsources/hosts-file.net/src/master/
# echo "Downloading Active hosts-file.net...."

 hpLists=(ad_servers emd exp fsa grm hjk mmt psh pup)
 hpUrl="https://bitbucket.org/expiredsources/hosts-file.net/raw/master/active/"

 for d in "${hpLists[@]}"; do
     mkdir -p "${git_dir}/data/hphosts/${d}"
     echo -e "\tImporting ${d}"
     touch "data/hphosts/${d}/domain.csv"
     ${WGET} -qO- "${hpUrl}/${d}.txt" | grep -vE '^(#|$)' >"data/hphosts/${d}/domain.csv"
 done

 # For protecting the future devs we unset variables
 hpUrl=""

 echo "Puuh.. done importing Active hosts-file.net...."

# blocklistproject CNAME blocklist-site
# This url is bullshit, trying to bump his own domain. Bullshit url="bsUrl="https://blocklist.site/app/dl/""
# bsLists=(abuse ads crypto drugs facebook fraud gambling malware phishing piracy porn ransomware redirect scam torrent tracking)
# bsUrl="https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/"

# echo "Importing blocklistproject"
# for bs in "${bsLists[@]}"; do
#     mkdir -p "${git_dir}/data/blocklist_${bs}"
#     echo -e "\t- ${bs}"
#     c "${bsUrl}${bs}-nl.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",tolower($1)) }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u >"data/blocklist_${bs}/domain.csv"
# done

# Unset variables
# bsUrl=""

 echo "Imported blocklist.site"

# Moved to urls-to-domains.php
# mkdir -p "${git_dir}/data/BBcan177_MS-4/" "${git_dir}/data/BBcan177_MS-2/"
# c "https://gist.githubusercontent.com/BBcan177/b6df57cef74e28d90acf1eec93d62d3b/raw/f0996cf5248657ada2adb396f3636be8716b99eb/MS-4" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/BBcan177_MS-4/domain.csv"
# c "https://gist.githubusercontent.com/BBcan177/4a8bf37c131be4803cb2/raw/343ff780e15205b4dd0de37c86af34cfb26b2fbe/MS-2" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/BBcan177_MS-2/domain.csv"
# echo "Imported BBcan177"

  name="phishing_army_blocklist_extended"
  mkdir -p "${git_dir}/data/$name/"
  ${WGET} -qO- "https://phishing.army/download/phishing_army_blocklist_extended.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/phishing_army_blocklist_extended/domain.csv"
  echo "Imported $name"

# spamhaus.org
# drop
mkdir -p "${git_dir}/data/spamhaus/drop/"
${WGET} -qO- "https://www.spamhaus.org/drop/drop.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sed 's/ \;.*$//' | awk -F "[/.]" '{  printf("%s.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n%s.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$5,$4,$3,$2,$1,$5,$4,$3,$2,$1) }' >"data/spamhaus/drop/ipv4.in-addr.arpa"
echo "Imported Drop spamhaus.org"

# implanting .dtq from https://www.mypdns.org/w/ixfrdist/#532

# Edrop
mkdir -p "${git_dir}/data/spamhaus/edrop/"
${WGET} -qO- "https://www.spamhaus.org/drop/edrop.txt" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sed 's/ \;.*$//' | awk -F "[/.]" '{  printf("%s.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n%s.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$5,$4,$3,$2,$1,$5,$4,$3,$2,$1) }' >"data/spamhaus/edrop/ipv4.in-addr.arpa"
echo "Imported eDrop spamhaus.org"

# coinblocker
# mkdir -p "${git_dir}/data/spamhaustech/coinblocker/"
# drill axfr coinblocker.srv @35.156.219.71 -p 53 | grep -vE "^(;|$)|(SOA|NS)" | sed -e 's/\.coinblocker\.srv\.[[:blank:]].*$//g' >"data/spamhaustech/coinblocker/domain.csv"
# echo "Imported coinblocker .dtq"

 # Disconnect ad-servers
 mkdir -p "${git_dir}/data/disconnect-me/"
 c "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' >"data/disconnect-me/domain.csv"
 echo "Imported simple disconnect.me"

# We need to avoid the IP hosts provided by openfish as they can't be used with hosts files'
 mkdir -p "${git_dir}/data/openfish/"
 c "https://openphish.com/feed.txt" | awk -F "/" '!/^($|#)/{ print $3 | "sort -u | uniq -u -i " }' | grep -Ev "\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\b" >"data/openfish/domain.csv"
 c "https://openphish.com/feed.txt" | awk -F "/" '!/^($|#)/{ print $3 | "sort -u | uniq -u -i " }' | grep -E "\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\b" | awk -F "." '{  printf("32.%s.%s.%s.%s.rpz-ip\tCNAME\t.\n32.%s.%s.%s.%s.rpz-client-ip\tCNAME\trpz-drop.\n",$4,$3,$2,$1,$4,$3,$2,$1) }' >"data/openfish/ipv4.in-addr.arpa"
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
     python3 "${git_dir}/scripts/domain-sort.py" >"${git_dir}/data/phishing_database/ALL-phishing-links.txt"

# | sort -u | python3 "${git_dir}/scripts/domain-sort.py" >"data/phishing_database/ALL-phishing-links.txt"

 echo "Done importing Phishing Database"
 echo ""

mkdir -p "${git_dir}/data/mitchellkrogza/badd_boyz_hosts/"
echo ""
echo "Badd-Boyz-Hosts"
echo ""
${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts" | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/mitchellkrogza/badd_boyz_hosts/domain.csv"
 ${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/README.md" -O "data/mitchellkrogza/badd_boyz_hosts/README.md"
 ${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/LICENSE.md" -O "data/mitchellkrogza/badd_boyz_hosts/LICENSE.md"

 mkdir -p "${git_dir}/data/mitchellkrogza/the-big-list-of-hacked-malware-web-sites/"
 echo ""
 echo "The-Big-List-of-Hacked-Malware-Web-Sites"
 echo ""
 ${WGET} -qO- "https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/hacked-domains.csv" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"data/mitchellkrogza/the-big-list-of-hacked-malware-web-sites/domain.csv"
 ${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/README.md" -O "data/mitchellkrogza/the-big-list-of-hacked-malware-web-sites/README.md"
 ${WGET} -q "https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/LICENSE.md" -O "data/mitchellkrogza/the-big-list-of-hacked-malware-web-sites/LICENSE.md"

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

 mkdir -p "${git_dir}/data/mitchellkrogza/Ultimate.Hosts.Blacklist/"
 echo ""
 echo "Ultimate.Hosts.Blacklist: Start"
 echo ""
 echo "list"
 c "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/master/domains/domains0.csv" | grep -vE "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$" >"data/mitchellkrogza/Ultimate.Hosts.Blacklist/domain.csv"
 echo "readme"
 c "https://raw.githubusercontent.com/mitchellkrogza/Ultimate.Hosts.Blacklist/master/README.md" -o "data/mitchellkrogza/Ultimate.Hosts.Blacklist/README.md"
 echo "LICENSE"
 c "https://raw.githubusercontent.com/mitchellkrogza/Ultimate.Hosts.Blacklist/master/LICENSE.md" -o "data/mitchellkrogza/Ultimate.Hosts.Blacklist/LICENSE.md"
 echo "Ultimate.Hosts.Blacklist: End"
# END @mitchellkrogza's many lists
 echo "@mitchellkrogza's lists: END"

 echo ""
 echo "Importing 1Hosts"
 echo ""
 mkdir -p "${git_dir}/data/1Hosts"
 ${WGET} -qO- "https://raw.githubusercontent.com/badmojr/1Hosts/master/Xtra/domains.txt" | awk '/^(#|$)/{ next }; /^Site/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",$1) | "sort -u -i" }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' >"${git_dir}/data/domain.csv"

 muLists=(malware ads-tracking ads-tracking-breaking)
 muUrl="https://raw.githubusercontent.com/migueldemoura/ublock-umatrix-rulesets/master/Hosts/"

 for mu in "${muLists[@]}"; do
     mkdir -p "${git_dir}/data/migueldemoura_${mu}"
     echo "Importing ${mu}"
     c "${muUrl}${mu}" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",tolower($1)) }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u >"data/migueldemoura_${mu}/domain.csv"
 done

# Unset variables
 muUrl=""

# @ShadowWhisperer

echo "Let's import @ShadowWhisperer"

SWLists=(Ads Apple Bloat Chat Cryptocurrency Dating Dynamic Free Junk Malware Marketing Marketing-Email Microsoft Remote Risk Scam Shock Tracking Tunnels Typo UrlShortener)
SWUrl="https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master"

for SW in "${SWLists[@]}"; do
    mkdir -p "${git_dir}/data/shadowwhisperer/${SW}"
    echo "Importing @ShadowWhisperer ${SW}"
    c "${SWUrl}/Lists/${SW}" | awk '/^(#|$)/{ next }; { if ( $1 ~ /[a-z]/ ) printf("%s\n",tolower($1)) }' | perl -lpe 's/^\s*(.*\S)\s*$/$1/' | sort | uniq -u >"$git_dir/data/shadowwhisperer/${SW}/domain.csv"
done

echo "Import README"

${WGET} "${SWUrl}/README.md" -O "$git_dir/data/shadowwhisperer/README.md"

# Unset variables
SWUrl=""

echo "Done with @ShadowWhisperer, thanks for your contribution, may the the ods"
echo "always be in your favour :smirk:"

# Geoffrey Frog eye's block list of first-party trackers
# First party trackers only
echo "Importing Geoffrey Frog eye's block list of first-party trackers"
mkdir -p "${git_dir}/data/frogeye/{firstpart,firstpart2,thirdpart}"
c https://hostfiles.frogeye.fr/firstparty-trackers.txt -o "${git_dir}/data/frogeye/firstpart/domain.csv"
c https://hostfiles.frogeye.fr/firstparty-only-trackers.txt -o "${git_dir}/data/frogeye/firstpart2/domain.csv"
c https://hostfiles.frogeye.fr/multiparty-only-trackers.txt -o "${git_dir}/data/frogeye/thirdpart/domain.csv"
echo "Done importing Geoffrey Frog eye's block list of first-party trackers"

# Quidsup Mixed
mkdir -p "${git_dir}/data/quidsup/"
c https://quidsup.net/notrack/blocklist.php?download=trackersdomains -o "${git_dir}/data/quidsup/domain.csv"
echo "Done importing Quidsup"

# fabriziosalmi
name="fabriziosalmi"
mkdir -p "${git_dir}/data/$name/"
c https://github.com/fabriziosalmi/blacklists/releases/download/latest/blacklist.txt -o "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

# mineNu | This list is not public available
name="mineNu"
mkdir -p "${git_dir}/data/$name/"
c https://hostsfile.mine.nu/hosts0.txt | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

# HostsFileOrg
name="HostsFileOrg"
mkdir -p "${git_dir}/data/$name/"
c https://hostsfile.org/Downloads/hosts.txt | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

# digitalside | This list is not public available
name="digitalside"
mkdir -p "${git_dir}/data/$name/"
c https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

# BarbBlock
name="BarbBlock"
mkdir -p "${git_dir}/data/$name/"
c https://github.com/Anonymous941/BarbBlock/blob/main/blocklists/domain-list.txt | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

# phishingArmy
name="phishingArmy"
mkdir -p "${git_dir}/data/$name/"
c https://phishing.army/download/phishing_army_blocklist_extended.txt | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($1)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

# AssoEchap
name="AssoEchap"
mkdir -p "${git_dir}/data/$name/"
c https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts_full | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($1)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

# KADhosts_azet12
name="KADhosts_azet12"
mkdir -p "${git_dir}/data/$name/"
c https://raw.githubusercontent.com/FiltersHeroes/KADhosts/master/KADomains.txt | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($1)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

# phishing-block-list
name="phishing-block-list"
mkdir -p "${git_dir}/data/$name/"
c https://raw.githubusercontent.com/chainapsis/phishing-block-list/main/block-list.txt | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($1)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

# adblock-nocoin-list
name="adblock-nocoin-list"
mkdir -p "${git_dir}/data/$name/"
c https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

#
name=""
mkdir -p "${git_dir}/data/$name/"
c  | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

#
name=""
mkdir -p "${git_dir}/data/$name/"
c  | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

#
name=""
mkdir -p "${git_dir}/data/$name/"
c  | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"

#
name=""
mkdir -p "${git_dir}/data/$name/"
c  | awk '/localhost/{next}; /^(#|$)/{ next }; { if ( $1 ~ /^[0-9]/ ) printf("%s\n",tolower($2)) | "sort -i | uniq -u -i " }' > "${git_dir}/data/$name/domain.csv"
echo "Imported $name"
echo ""
echo ""
echo "The script ${0}"
# shellcheck disable=SC2320
echo -e "Exited with error code ${?}\n\n"

# git add .

# tag=$(date +'day: %j of year %Y %H:%M:%S')

# git commit -a -m "New release ${tag}" && git push

