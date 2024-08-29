<?php

/** SETTINGS *************************************************************/

// Parse CLI arguments into the $_GET global.
if ( isset( $argv ) ) {
    parse_str( implode( '&', array_slice( $argv, 1 ) ), $_GET );
}

// Parse list from CLI parameters if available.
if ( ! empty( $_GET['url'] ) && ! empty( $_GET['name'] ) ) {
    $lists = [
        $_GET['name'] => $_GET['url']
    ];

// Default lists.
} else {
    // Add our lists.
    $lists = array(
//        '1Hosts' => 'https://raw.githubusercontent.com/badmojr/1Hosts/master/Xtra/domains.txt',
//        'Adaway' => 'https://adaway.org/hosts.txt',
//        'AdroitAdorKhan' => 'https://raw.githubusercontent.com/AdroitAdorKhan/antipopads-re/master/formats/hosts.txt',
        'PhishingDatabaseLinks' => 'https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/ALL-phishing-links.txt',
        'fabriziosalmi' => 'https://github.com/fabriziosalmi/blacklists/releases/download/latest/blacklist.txt',
        'openphish_com' => 'https://openphish.com/feed.txt',
        'mineNu' => 'https://hostsfile.mine.nu/hosts0.txt', // This list is not public available
        'HostsFileOrg' => 'https://hostsfile.org/Downloads/hosts.txt', // Whitelists BigTech
        'digitalside' => 'https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt', // This list is not public available
        'BarbBlock' => 'https://github.com/Anonymous941/BarbBlock/blob/main/blocklists/domain-list.txt',
        'phishingArmy' => 'https://phishing.army/download/phishing_army_blocklist_extended.txt',
        'AssoEchap' => 'https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts_full',
        'KADhosts_azet12' => 'https://raw.githubusercontent.com/FiltersHeroes/KADhosts/master/KADomains.txt',
        'phishing-block-list' => 'https://raw.githubusercontent.com/chainapsis/phishing-block-list/main/block-list.txt',
        'adblock-nocoin-list' => 'https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt',
        'matomoSpammers' => 'https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt',
        'neodevhost' => 'https://raw.githubusercontent.com/neodevpro/neodevhost/master/domain',
        'pengelana' => 'https://raw.githubusercontent.com/pengelana/blocklist/master/src/domain.txt',
        'scamaNet' => 'https://raw.githubusercontent.com/scamaNet/blocklist/main/blocklist.txt',
        'sysctl' => 'https://sysctl.org/cameleon/hosts',
        'stopforumspam' => 'https://www.stopforumspam.com/downloads/toxic_domains_whole.txt',

        // FadeMind
        'FadeMindRisk' => 'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts',
        'FadeMindSpam' => 'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts',
        'FadeMindPopAds' => 'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/antipopads-re/hosts',
        'FadeMindFacebook' => 'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/blocklists-facebook/hosts',

        // ABPindo
        'ABPindoDomain' => 'https://raw.githubusercontent.com/ABPindo/indonesianadblockrules/master/subscriptions/domain.txt',
        'ABPindoAdult' => 'https://raw.githubusercontent.com/ABPindo/indonesianadblockrules/master/subscriptions/domain_adult.txt',

        // BBcan177
        'BBcan177_MS-2' => 'https://gist.githubusercontent.com/BBcan177/4a8bf37c131be4803cb2/raw/77eee956303e8d6ff2f4df61d3e2c0b60d023268/MS-2',
        'BBcan177_MS-4' => 'https://gist.githubusercontent.com/BBcan177/b6df57cef74e28d90acf1eec93d62d3b/raw/f0996cf5248657ada2adb396f3636be8716b99eb/MS-4',
        'BBcan177_Crypto' => 'https://raw.githubusercontent.com/BBcan177/minerchk/master/hostslist.txt',
        'BBcan177_spam' => 'https://raw.githubusercontent.com/BBcan177/referrer-spam-blacklist/master/spammers.txt',

        // Geoffrey Frog eye's block list
        'FrogEye_fpt' => 'https://hostfiles.frogeye.fr/firstparty-trackers.txt',
        'FrogEye_fpot' => 'https://hostfiles.frogeye.fr/firstparty-only-trackers.txt',
        'FrogEye_mpt' => 'https://hostfiles.frogeye.fr/multiparty-only-trackers.txt',

        // quidsup https://quidsup.net/notrack/blocklist.php
        'quidsupAnnoyance' => 'https://quidsup.net/notrack/blocklist.php?download=annoyancedomains',
        'quidsupMalware' => 'https://quidsup.net/notrack/blocklist.php?download=malwaredomains',
        'quidsupTrackers' => 'https://quidsup.net/notrack/blocklist.php?download=trackersdomains',
        'hole.cert.pl' => 'https://hole.cert.pl/domains/domains.txt',
    );
}

foreach ( $lists as $name => $list ) {
    echo "Converting urls and hosts {$name}...\n";

    // Fetch list and explode into an array.
    $lines = file_get_contents( $list );
    $lines = explode( "\n", $lines );

    // HOSTS header.
    $hosts  = "# {$name}\n";
    $hosts .= "#\n";
    $hosts .= "# Converted from - {$list}\n";
    $hosts .= "# Last converted - " . date( 'r' ) . "\n";
    $hosts .= "#\n\n";

    $domains = array();

    // Loop through each url.
    foreach ( $lines as $url ) {
        if ( 0 === strpos( $url, '#' ) ) {
            continue;
        }

        // Test for hosts file. If so, split by space.
        if ( is_numeric( substr( $url, 0, 1 ) ) && false !== strpos( $url, ' ' ) ) {
            $url = explode( ' ', $url );
            $url = 'https://' . end( $url );
        }

        $url = trim( $url );
        if ( empty( $url ) ) {
            continue;
        }

        $host = parse_url( $url, PHP_URL_HOST );
        if ( empty( $host ) ) {
            continue;
        }

        if ( isset( $domains[ $host ] ) ) {
            continue;
        }

        $domains[ $host ] = 1;
    }

    // Generate the hosts list.
    if ( ! empty( $domains ) ) {
        $domains = array_keys( $domains );

        $hosts .= implode( "\n", $domains );
        unset( $domains );
    }

    // Output the file.
    file_put_contents( "data/{$name}.txt", $hosts );

    echo "{$name} converted to domains file - see {$name}.txt\n";
}