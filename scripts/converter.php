<?php
//script source https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/converter.php
// Add our lists.
$lists = array(
    'adAway' => 'https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt',
    'adguardApps' => 'https://github.com/AdguardTeam/AdguardFilters/raw/master/MobileFilter/sections/specific_app.txt',
    'adguardDNS' => 'https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt',
    'adguardMobileAds' => 'https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/MobileFilter/sections/adservers.txt',
    'antipopadsRe' => 'https://raw.githubusercontent.com/AdroitAdorKhan/antipopads-re/master/formats/hosts.txt',
    'anudeepND' => 'https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt',
    'BaddBoyzHosts' => 'https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts',
    'badmojr1Hosts' => 'https://raw.githubusercontent.com/badmojr/1Hosts/master/Xtra/domains.txt',
    'BBcan177MS2' => 'https://gist.githubusercontent.com/BBcan177/4a8bf37c131be4803cb2/raw/343ff780e15205b4dd0de37c86af34cfb26b2fbe/MS-2',
    'BBcan177MS4' => 'https://gist.githubusercontent.com/BBcan177/b6df57cef74e28d90acf1eec93d62d3b/raw/f0996cf5248657ada2adb396f3636be8716b99eb/MS-4',
    // 'blocklistProjectAbuse' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/abuse-nl.txt',
    // 'blocklistProjectAds' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/ads-nl.txt',
    // 'blocklistProjectCrypto' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/crypto-nl.txt',
    // 'blocklistProjectDrugs' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/drugs-nl.txt',
    // 'blocklistProjectFacebook' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/facebook-nl.txt',
    // 'blocklistProjectFraud' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/fraud-nl.txt',
    // 'blocklistProjectGambling' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/gambling-nl.txt',
    // 'blocklistProjectMalware' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/malware-nl.txt',
    // 'blocklistProjectPhishing' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/phishing-nl.txt',
    // 'blocklistProjectPiracy' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/piracy-nl.txt',
    // 'blocklistProjectPorn' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/porn-nl.txt',
    // 'blocklistProjectRansomware' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/ransomware-nl.txt',
    // 'blocklistProjectRedirect' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/redirect-nl.txt',
    // 'blocklistProjectScam' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/scam-nl.txt',
    // 'blocklistProjectTorrent' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/torrent-nl.txt',
    // 'blocklistProjectTracking' => 'https://raw.githubusercontent.com/blocklistproject/Lists/master/alt-version/tracking-nl.txt',
    // 'blocklistsFacebook' => 'https://raw.githubusercontent.com/jmdugan/blocklists/master/corporations/facebook/all',
    'coinBlockerLists' => 'https://zerodot1.gitlab.io/CoinBlockerLists/list.txt',
    'disconnectMe' => 'https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt',
    'easyPrivacy3rdParty' => 'https://raw.githubusercontent.com/easylist/easylist/master/easyprivacy/easyprivacy_thirdparty.txt',
    'easyPrivacySpecific' => 'https://github.com/easylist/easylist/raw/master/easyprivacy/easyprivacy_specific.txt',
    'fadeMindAddRisk' => 'https://github.com/FadeMind/hosts.extras/raw/master/add.Risk/hosts',
    'fadeMindAddSpam' => 'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts',
    'geoffreyFrogeyeFirstPartyTrackers' => 'https://hostfiles.frogeye.fr/firstparty-trackers.txt',
    'geoffreyFrogeyeMultiPartyTrackers' => 'https://hostfiles.frogeye.fr/multiparty-trackers.txt',
    'migueldemouraAdsTracking' => 'https://raw.githubusercontent.com/migueldemoura/ublock-umatrix-rulesets/master/Hosts/ads-tracking',
    'migueldemouraAdsTrackingBreaking' => 'https://raw.githubusercontent.com/migueldemoura/ublock-umatrix-rulesets/master/Hosts/ads-tracking-breaking',
    'migueldemouraMalware' => 'https://raw.githubusercontent.com/migueldemoura/ublock-umatrix-rulesets/master/Hosts/malware',
    'notrackBlocklist' => 'https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt',
    'notrackMalware' => 'https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt',
    'PglYoYo' => 'https://pgl.yoyo.org/adservers/serverlist.php?hostformat=one-line&showintro=0&mimetype=plaintext',
    'phishingArmy' => 'https://phishing.army/download/phishing_army_blocklist_extended.txt',
    'Phishing.Database' => 'https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/phishing-domains-ACTIVE.txt',
    'Phishing.DatabaseAll' => 'https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/ALL-phishing-domains.txt',
    'Phishing.DatabaseAllLinks' => 'https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/ALL-phishing-links.txt',
    'QuidsupMixed' => 'https://quidsup.net/notrack/blocklist.php?download=trackersdomains',
    'ShadowWhispererAds' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Ads',
    'ShadowWhispererApple' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Apple',
    'ShadowWhispererBloat' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Bloat',
    'ShadowWhispererChat' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Chat',
    'ShadowWhispererCryptocurrency' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Cryptocurrency',
    'ShadowWhispererDating' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Dating',
    'ShadowWhispererDynamic' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Dynamic',
    'ShadowWhispererFree' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Free',
    'ShadowWhispererJunk' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Junk',
    'ShadowWhispererMalware' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Malware',
    'ShadowWhispererMarketing' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Marketing',
    'ShadowWhispererMarketingEmail ' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Marketing-Email',
    'ShadowWhispererMicrosoft' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Microsoft',
    'ShadowWhispererRemote' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Remote',
    'ShadowWhispererRisk' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Risk',
    'ShadowWhispererScam' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Scam',
    'ShadowWhispererShock' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Shock',
    'ShadowWhispererTracking' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Tracking',
    'ShadowWhispererTunnels' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Tunnels',
    'ShadowWhispererTypo' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Typo',
    'ShadowWhispererUrlShortener' => 'https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/UrlShortener',
    'someoneWhoCares' => 'https://someonewhocares.org/hosts/hosts',
    'TheBigListofHackedMalwareWebSites' => 'https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/hacked-domains.list',
    'UltimateHostsBlacklist0' => 'https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/master/domains/domains0.list',
    'UltimateHostsBlacklist1' => 'https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/master/domains/domains1.list',
    'UltimateHostsBlacklist2' => 'https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/master/domains/domains2.list',
    'urlHaus' => 'https://urlhaus.abuse.ch/downloads/rpz/',
    'winhelp2002' => 'https://winhelp2002.mvps.org/hosts.txt'
);

$idn_to_ascii = function_exists('idn_to_ascii');

foreach ($lists as $name => $list) {
    echo "Converting $name...\n";

    // Fetch filter list and explode into an array.
    $lines = file_get_contents($list);
    $lines = explode("\n", $lines);

    // HOSTS header.
    $hosts = "# $name\n";
    $hosts .= "#\n";
    $hosts .= "# Converted from - $list\n";
    $hosts .= '# Last converted - ' . date('r') . "\n";
    $hosts .= "#\n\n";

    $domains = $exceptions = array();

    // Loop through each ad filter.
    foreach ($lines as $filter) {
        // Skip filter if matches the following:
        if (false === strpos($filter, '.')) {
            continue;
        }
        if (false !== strpos($filter, '*')) {
            continue;
        }
        if (false !== strpos($filter, '/')) {
            continue;
        }
        if (false !== strpos($filter, '#')) {
            continue;
        }
        if (false !== strpos($filter, ' ')) {
            continue;
        }
        if (false !== strpos($filter, 'abp?')) {
            continue;
        }

        // Skip Adguard HTML filtering syntax.
        if (false !== strpos($filter, '$$') || false !== strpos($filter, '$@$')) {
            continue;
        }

        // For $domain syntax, strip domain rules.
        if (false !== strpos($filter, '$domain') && false === strpos($filter, '@@')) {
            $filter = substr($filter, 0, strpos($filter, '$domain'));
        } elseif (false !== strpos($filter, '=')) {
            continue;
        }

        // Replace filter syntax with HOSTS syntax.
        // @todo Perhaps skip $third-party, $image and $popup?
        $filter = str_replace(array('||', '^third-party', '^', '$third-party', ',third-party', '$all', ',all', '$image', ',image', ',important', '$script', ',script', '$object', ',object', '$popup', ',popup', '$empty', '$object-subrequest', '$document', '$subdocument', ',subdocument', '$ping', '$important', '$badfilter', ',badfilter', '$websocket', '$cookie', '$other'), '', $filter);

        /*
         * Workarounds. Groan.
         */
        // EasyPrivacySpecific. See https://github.com/r-a-y/mobile-hosts/issues/17.
        if ('soundcloud.com' === $filter) {
            continue;
        }
        // See https://github.com/r-a-y/mobile-hosts/issues/26.
        if ('global.ssl.fastly.net' === $filter) {
            continue;
        }

        // Skip rules matching 'xmlhttprequest' for now.
        if (false !== strpos($filter, 'xmlhttprequest')) {
            continue;
        }

        // Skip exclusion rules.
        if (false !== strpos($filter, '~')) {
            continue;
        }

        // Trim whitespace.
        $filter = trim($filter);

        // If starting or ending with '.', skip.
        if ('.' === substr($filter, 0, 1) || '.' === substr($filter, -1)) {
            continue;
        }

        // If starting with '-', skip.
        // https://github.com/r-a-y/mobile-hosts/issues/5
        if ('-' === substr($filter, 0, 1) || '_' === substr($filter, 0, 1)) {
            continue;
        }

        // If starting with '!', skip.
        if ('!' === substr($filter, 0, 1)) {
            continue;
        }

        // Strip trailing |.
        if ('|' === substr($filter, -1)) {
            $filter = str_replace('|', '', $filter);
        }

        // Skip file extensions
        if ('.jpg' === substr($filter, -4) || '.gif' === substr($filter, -4)) {
            continue;
        }

        // Strip port numbers.
        if (false !== strpos($filter, ':')) {
            $filter = substr($filter, 0, strpos($filter, ':'));
        }

        // Convert internationalized domain names to punycode.
        if ($idn_to_ascii && preg_match('//u', $filter)) {
            $filter = idn_to_ascii($filter);
        }

        // If empty, skip.
        if (empty($filter)) {
            continue;
        }

        // Save exception to parse later.
        if (0 === strpos($filter, '@@')) {
            $exceptions[] = '0.0.0.0 ' . str_replace('@@', '', $filter);
            continue;
        }

        $domains[] = "$filter";
    }

    // Generate the hosts list.
    if (!empty($domains)) {
        // Filter out duplicates.
        $domains = array_unique($domains);

        // Remove exceptions.
        if (!empty($exceptions)) {
            $domains = array_diff($domains, $exceptions);
        }

        $hosts .= implode("\n", $domains);
        unset($domains);
    }

    // Output the file.
    file_put_contents("data/${name}.txt", $hosts);

    echo "$name converted to HOSTS file - see data/${name}.txt\n";
}
