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
        'PhishingDatabaseLinks' => 'https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/ALL-phishing-links.txt',
        'openphish_com' => 'https://openphish.com/feed.txt',
        'quidsupTrackers' => 'https://uidsup.net/notrack/blocklist.php?download=trackersdomains',
        '1Hosts' => 'https://raw.githubusercontent.com/badmojr/1Hosts/master/Xtra/domains.txt',
        'AdroitAdorKhan' => 'https://raw.githubusercontent.com/AdroitAdorKhan/antipopads-re/master/formats/hosts.txt',
    );
}

foreach ( $lists as $name => $list ) {
    echo "Converting {$name}...\n";

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