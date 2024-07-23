<?php

// Add our lists.
$lists = array(
	'PhishingDatabaseLinks' => 'https://raw.githubusercontent.com/mitchellkrogza/Phishing.Database/master/ALL-phishing-links.txt',
    'openphish_com' => 'https://openphish.com/feed.txt'
);

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

	$domains = $exceptions = array();

	// Loop through each url.
	foreach ( $lines as $url ) {
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

	// Generate the domains list.
	if ( ! empty( $domains ) ) {
		$domains = array_keys( $domains );

		$hosts .= implode( "\n", $domains );
		unset( $domains );
	}

	// Output the file.
	file_put_contents( "data/{$name}.txt", $hosts );

	echo "{$name} converted to domains file - see {$name}.txt\n";
}