<h2 align="center"><a href="https://t.me/hostsTR" alt="Annoying Sites Telegram Group"><img src="https://raw.githubusercontent.com/xorcan/hosts/master/xorcan.hosts.logo.jpg" width="250"></a></br>
<b>Turkish Ad-list, Ad-Block List, HOSTS</b></h2><h4 align="center">Blocks annoying sites like betting and fraud. <a href="https://github.com/xorcan/hosts/blob/master/README.md">Türkçe</a></h4>

<p align="center"><a href="https://www.gnu.org/licenses/gpl-3.0" alt="License: GPLv3"><img src="https://img.shields.io/github/license/xorcan/hosts.svg"></a> <a href="https://www.google.com/search?&q=t%C3%BCrk+adlist+xorcan" alt="Türkçe Ad-listler"><img src="https://img.shields.io/badge/t%C3%BCrk%C3%A7e-reklam%20listesi-f44b42.svg"></a>  <a href="https://github.com/xorcan/hosts/issues" alt="Hatalar"><img src="https://img.shields.io/github/issues/xorcan/hosts.svg"></a> 

## Usage

Use with AdAway. Designed for Android.

## What is Recommended for Windows?

- You can effectively filter element by using [uBlock Origin](https://github.com/gorhill/uBlock) in your browser. To do so, first obtain the one for your browser:
- [uBlock Origin for Chrome](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm) -- 
[uBlock Origin for Firefox](https://addons.mozilla.org/tr/firefox/addon/ublock-origin/) -- 
[uBlock Origin for Opera](https://addons.opera.com/tr/extensions/details/ublock/)
- Go to uBlock Origin > Dashboard > Filter lists > Import (at the bottom) and add the following link to the drop-down link:
1. ```https://raw.githubusercontent.com/xorcan/hosts/master/xhosts.txt```
- You can then exit the page by clicking the "Apply Changes" button that appears at the top right.
- You no longer need to enter the settings page and press the "Update" button. The list will be updated periodically as other sites do. 
- NOTE: they won't be able to block all ads due to the hosts structure of this list. We can block ads from third parties only, and in many cases this filtering method is sufficient.

## What's Not Recommended for Windows?

- Copy the entire list by entering the following address:
1. ```https://raw.githubusercontent.com/xorcan/hosts/master/xhosts.txt```
- Locate the hosts file on your computer at C:\Windows\System32\drivers\etc.
- Open the hosts file with notepad ++, paste the list here and save and exit.
- Restart your computer.
- NOTE: Because you cannot add whitelist for Windows, you will only use the xhosts.txt file.

## For Android (AdAway (Root)) (Step 1/2)

If you have root access permission, you should change the phone's own "hosts" file. This saves battery and RAM.
If you have root access, you can use AdAway. Adaway is a free application that prevents advertising with Host files.

- Download the AdAway app [here](https://f-droid.org/packages/org.adaway/). (by clicking the "download apk" link under the "download f-droid" link)
- Install the application on your phone or tablet.
- Open the application and open the "Host Resources" tab from the application menu.
- Click '+' in the upper right corner. You will be prompted to enter a link.
- Copy and paste the following address into this section and add. (use with the whitelist.)
- (These are enough for my suggestions and normal Android users. If you say I want more [see here](https://github.com/xorcan/hosts/blob/master/OTHERS.md).

1. ```https://raw.githubusercontent.com/xorcan/hosts/master/xhosts.txt```
2. ```https://adaway.org/hosts.txt```
3. ```https://hosts-file.net/ad_servers.txt```
4. ```https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext```
5. ```https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts```
6. ```https://someonewhocares.org/hosts/hosts```
7. ```https://raw.githubusercontent.com/xorcan/disconnect.me-lists/master/simple_malvertising.txt```

- Return to the main menu, check for updates and apply them. Restart your device.

## Whitelist (for AdAway) (Step 2/2)

- You will download this list to your device and import it from "Your lists". It is necessary for some sites to work properly. If the list starts and ends immediately, you do not need to add it.

1. ```https://raw.githubusercontent.com/xorcan/hosts/master/xwhite.txt```

## Included lists (Swallowed)

By using this list provider, you automatically use the lists listed below. Don't worry, they will always be in the most up-to-date state. You don't need to add them that you understand.

1. ```https://raw.githubusercontent.com/deathbybandaid/piholeparser/master/Subscribable-Lists/ParsedBlacklists/Turk-adlist.txt```
2. ```https://raw.githubusercontent.com/biroloter/Mobile-Ad-Hosts/master/hosts```
3. ```https://raw.githubusercontent.com/bkrucarci/turk-adlist/master/hosts```
4. ```https://raw.githubusercontent.com/deathbybandaid/piholeparser/master/Subscribable-Lists/ParsedBlacklists/AakList.txt```

## [Other lists](https://github.com/xorcan/hosts/blob/master/OTHERS.md)

## Exceptions

The conditions specified here must be set manually, as they are not included in the files. Follow these rules:

- for add to blacklist: Go to "adaway > your" lists. Make sure "blacklist" is selected at the bottom, then click "+ (flying button)" and type the specified part.
- for add to whitelist: Go to "adaway > your" lists. Make sure "whitelist" is selected at the bottom, then click "+ (flying button)" and type the specified part.

### optional blacklist

1. ```ads.facebook.com``` for Facebook ads.

## How do I report a annoying site?

Report sites that you deem appropriate, let's add them to the list so other people don't deal with them.

1. Report with using [Issues](https://github.com/xorcan/hosts/issues).
2. Report with using [e-Mail](mailto:xorcan@yandex.com).
3. Report with using [Anonymous (without login) mail](https://anonymousemail.me) to ```xorcan@yandex.com```.
4. Report with using [Telegram](https://t.me/hostsTR) group.

## Warning

Please read the privacy agreements of the applications in this article. If you don't know what you're doing, stay away from them. The structure of each device is different, the article editor cannot be held responsible for any problems that may occur.

## License

[![GNU GPLv3 Image](https://www.gnu.org/graphics/gplv3-127x51.png)](http://www.gnu.org/licenses/gpl-3.0.en.html)  

All responsibility belongs to the user. You can use, study share and improve it at your will. Specifically you can redistribute and/or modify it under the terms of the [GNU General Public License](https://www.gnu.org/licenses/gpl.html) as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. 
