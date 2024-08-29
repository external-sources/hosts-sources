<?php
// script source https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/converter.php
// https://github.com/r-a-y/mobile-hosts/blob/master/
// License: GPL-3.0 https://github.com/r-a-y/mobile-hosts/blob/master/LICENSE
/** SETTINGS *************************************************************/

// Parse CLI arguments into the $_GET global.
if (isset($argv)) {
    parse_str(implode('&', array_slice($argv, 1)), $_GET);
}

// Parse list from CLI parameters if available.
if (!empty($_GET['url']) && !empty($_GET['name'])) {
    $lists = [
        $_GET['name'] => $_GET['url']
    ];

// Default lists.
} else {
    $lists = array(
        // Mobile Ads
        'AdguardMobileAds' => 'https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_11_Mobile/filter.txt',

        // Mobile Tracking + Spyware
        'AdguardMobileSpyware' => 'https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/mobile.txt',

        // Adguard DNS
        'AdguardDNS' => 'https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt',

        // Adguard CNAME Ads
        'AdguardCNAMEAds' => 'https://raw.githubusercontent.com/AdguardTeam/cname-trackers/master/data/combined_disguised_ads.txt',

        // Adguard CNAME Click through
        'AdguardCNAMEClickthroughs' => 'https://raw.githubusercontent.com/AdguardTeam/cname-trackers/master/data/combined_disguised_clickthroughs.txt',

        // Adguard CNAME Microsites
        'AdguardCNAMEMicrosites' => 'https://raw.githubusercontent.com/AdguardTeam/cname-trackers/master/data/combined_disguised_microsites.txt',

        // Adguard CNAME Trackers
        'AdguardCNAME' => 'https://raw.githubusercontent.com/AdguardTeam/cname-trackers/master/data/combined_disguised_trackers.txt',

        // Adguard Tracking
        'AdguardTracking' => 'https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_3_Spyware/filter.txt',

        // EasyPrivacy Specific
        'EasyPrivacySpecific' => 'https://raw.githubusercontent.com/easylist/easylist/master/easyprivacy/easyprivacy_specific.txt',

        // EasyPrivacy Third-Party
        'EasyPrivacy3rdParty' => 'https://raw.githubusercontent.com/easylist/easylist/master/easyprivacy/easyprivacy_thirdparty.txt',

        // adblock.gardar.net list for icelandic websites.
        'icelandic.abp.txt' => 'https://adblock.gardar.net/is.abp.txt',

        // Adblock Plus
        'abp_advblock' => 'https://easylist-downloads.adblockplus.org/advblock.txt',
        'abp_antiadblockfilters' => 'https://easylist-downloads.adblockplus.org/antiadblockfilters.txt',
        'abp_easylistchina' => 'https://easylist-downloads.adblockplus.org/easylistchina.txt',
        'abp_easylistlithuania_easylist' => 'https://easylist-downloads.adblockplus.org/easylistlithuania+easylist.txt',

        // Not a bug LV
        'notabugLV' => 'https://notabug.org/latvian-list/adblock-latvian/raw/master/lists/latvian-list.txt',

        // betterwebleon slovenian
        'betterwebleonSlovenian' => 'https://raw.githubusercontent.com/betterwebleon/slovenian-list/master/filters.txt',

        //
        'cjxlist' => 'https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt',

        // EasyList Czech and Slovak
        'easylistczechandslovak' => 'https://raw.githubusercontent.com/tomasko126/easylistczechandslovak/master/filters.txt',

        //
        'YousList' => 'https://raw.githubusercontent.com/yous/YousList/master/youslist.txt',

        //
        'stanev' => 'https://stanev.org/abp/adblock_bg.txt',

        // Romanian Adblock List
        'RomanianAdblockList' => 'https://zoso.ro/pages/rolist.txt'
    );
}

/** PARSER ***************************************************************/

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
    $hosts .= "# Last converted - " . date('r') . "\n";
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
        if ($idn_to_ascii && preg_match("//u", $filter) && !empty($filter)) {
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
    file_put_contents("data/$name.txt", $hosts);

    echo "$name converted to HOSTS file - see $name.txt\n";
}