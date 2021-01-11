<h2 align="center"><a href="https://www.google.com/search?&q=t%C3%BCrk+adlist+xorcan" alt="Annoying Sites xorcan türk-adlist"><img src="./ivirzivir/xorcan.hosts.logo.jpg" width="250"></a></br>
<b>Turkish Ad-list, Ad-Block List, HOSTS</b></h2><h4 align="center">Blocks annoying sites like betting and fraud. <a href="https://github.com/xorcan/hosts/blob/master/README.md">Türkçe</a></h4>

<p align="center"><a href="https://www.gnu.org/licenses/gpl-3.0" alt="License: GPLv3"><img src="https://img.shields.io/github/license/xorcan/hosts.svg"></a> <a href="https://www.google.com/search?&q=t%C3%BCrk+adlist+xorcan" alt="Türkçe Ad-listler"><img src="https://img.shields.io/badge/t%C3%BCrk%C3%A7e-reklam%20listesi-f44b42.svg"></a>  <a href="https://github.com/xorcan/hosts/issues" alt="Hatalar"><img src="https://img.shields.io/github/issues/xorcan/hosts.svg"></a> <a href="https://github.com/xorcan/hosts" alt="Görüntülenme Sayısı"><img src="https://visitor-badge.laobi.icu/badge?page_id=xorcan.hosts"></a>

## Usage and Warning

Use with AdAway. Designed for -mostly- Android. I have recommended Nano Adblocker before. Remove nano **from your devices** and install **ublock origin**. Because nano adblocker is now a virus!

Detailed information (Turkish): [bilgiler 1](https://eksisozluk.com/nano-defender--5646917?a=nice) - [bilgiler 2](https://eksisozluk.com/nano-adblocker--5649314?a=nice)

## What is Recommended for Windows?

- You can effectively filter element by using [uBlock Origin](https://github.com/gorhill/uBlock) in your browser. To do so, first obtain the one for your browser: [for Chrome](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm?hl=tr) - 
[for Firefox](https://addons.mozilla.org/tr/firefox/addon/ublock-origin/) - [for Edge](https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak) - [for Opera](https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak)

- Go to **uBlock Origin > Dashboard > Filter lists > Import (at the bottom)** and add the following link to the drop-down link:

```
https://raw.githubusercontent.com/xorcan/hosts/master/xhosts.txt
https://raw.githubusercontent.com/xorcan/hosts/master/xelement.txt
https://raw.githubusercontent.com/xorcan/hosts/master/xips.txt
```

- Also lists I recommend you add:

```
https://raw.githubusercontent.com/bogachenko/fuckfuckadblock/master/fuckfuckadblock.txt
https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser
```

![like this](./ivirzivir/bilgi1.png)

- You can then exit the page by clicking the **"Apply Changes"** button that appears at the top right.
- You no longer need to enter the settings page and press the **"Update"** button. The list will be updated periodically as other sites do. 

## When Your Settings Are Finished It Should Look Like This:

![like this](./ivirzivir/bilgi2.png)

## What's Not Recommended for Windows?

This is for advanced users only. Do not make this setting if you do not know what it is!
Copy the entire list by entering the following address:

```https://raw.githubusercontent.com/xorcan/hosts/master/xhosts.txt```

- Locate the hosts file on your computer at C:\Windows\System32\drivers\etc.
- Open the hosts file with notepad ++, paste the list here and save and exit.
- Restart your computer.

## Options for Android

Free software can generally block advertisements at the hosts level and most of the time it cannot block advertisements in applications.

### AdGuard for Android // paid - if the device is not root-accessible

AdGuard software for Android can be said to be the best in this regard. It offers you the possibility to use many filters in the paid (Premium) version and uses a more advanced ad blocking technology. As I said, this app is paid and [has been removed from Google Play because Google ad policies didn't work for it](https://blog.adguard.com/en/google-removes-adguard-android-app-google-play/).
- [AdGuard for Android](https://adguard.com/tr/adguard-android/overview.html)
- Easy to install and use, no ROOT required.
- You can try the full version for free for 14 days,
- You can enable any filters (same as above) from the settings.
- Change the filtering method to "High Quality".
- It can block ad networks and applications (such as Youtube ads) using HTTPS.

### DNS66 // free - if the device is not root-accessible

Rooting your phone can be difficult and risky. It may take your phone out of warranty. If your phone is not rooted, you can block ads with the steps below.

- Download [DNS66](https://github.com/julian-klode/dns66/releases) application (".apk" extension in Assets section and always the top file).
- Allow unknown sources warning. Install the application on your phone / tablet.
- Open the application, tap the "Domain Filters" tab at the bottom.
- Tap the plus (plus) icon at the bottom right and type the following values.
- Title: xorcan adlist
- Location: ```https://raw.githubusercontent.com/xorcan/hosts/master/xhosts.txt```
- Action: Deny
- Save these settings by saying "Save" in the top right. Download updates by tapping the refresh button above.
- Switch to the Start / Stop menu, long tap the screen and enable filtering.
- If you see a key sign in the notification area, our filters are active. You can browse without ads.

### AdAway (Root) // free, recommended, charge friendly, if the device is root-accessible

If you have root access permission, you should change the phone's own "hosts" file. This saves battery and RAM.
If you have root access, you can use the AdAway application. It is a free application that blocks advertisements with host files.

- Download the AdAway application [here](https://github.com/AdAway/AdAway/releases) (with the ".apk" extension in the Assets section and always the top file).
- Install the application on your phone or tablet.
- Open the application and open the "Host resources" tab from the application menu.
- Tap the '+' sign in the upper right corner. You will be asked to enter a link.
- Copy non ** from the addresses below and paste it into this part and add it.
- (These are my recommendations and are sufficient for normal Android users. If you want more, you can check [here](https://github.com/xorcan/hosts/blob/master/OTHERS.md).)

```
https://raw.githubusercontent.com/xorcan/hosts/master/xhosts.txt
https://adaway.org/hosts.txt
https://hosts-file.net/ad_servers.txt
https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://someonewhocares.org/hosts/hosts
https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt
```

- Go back to the main menu, check and apply updates. Restart your device.

### Plugin browsers // free, device root-accessible

In a browser with add-on support such as Kiwi Browser or Mozilla Firefox, you can apply the same by installing an ublock origin from the add-ons section.

## Included lists (Swallowed)

By using this list provider, you automatically use the lists listed below. Don't worry, they will always be in the most up-to-date state. You don't need to add them that you understand.

```
https://raw.githubusercontent.com/deathbybandaid/piholeparser/master/Subscribable-Lists/ParsedBlacklists/Turk-adlist.txt
https://raw.githubusercontent.com/biroloter/Mobile-Ad-Hosts/master/hosts
https://raw.githubusercontent.com/bkrucarci/turk-adlist/master/hosts
https://raw.githubusercontent.com/deathbybandaid/piholeparser/master/Subscribable-Lists/ParsedBlacklists/AakList.txt
```

## [Other lists](https://github.com/xorcan/hosts/blob/master/OTHERS.md)

## Exceptions

The conditions specified here must be set manually, as they are not included in the files. Follow these rules:

- for add to blacklist: Go to "adaway > your" lists. Make sure "blacklist" is selected at the bottom, then click "+ (flying button)" and type the specified part.
- for add to whitelist: Go to "adaway > your" lists. Make sure "whitelist" is selected at the bottom, then click "+ (flying button)" and type the specified part.

### optional blacklist

1. ```ads.facebook.com``` for Facebook ads.

## How do I report a annoying site?

[Report](https://github.com/xorcan/hosts/issues) sites that you deem appropriate, let's add them to the list so other people don't deal with them.

## Warning

Please read the privacy agreements of the applications in this article. If you don't know what you're doing, stay away from them. The structure of each device is different, the article editor cannot be held responsible for any problems that may occur.

## License

[![GNU GPLv3 Image](https://www.gnu.org/graphics/gplv3-127x51.png)](http://www.gnu.org/licenses/gpl-3.0.en.html)  

All responsibility belongs to the user. You can use, study share and improve it at your will. Specifically you can redistribute and/or modify it under the terms of the [GNU General Public License](https://www.gnu.org/licenses/gpl.html) as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. 
