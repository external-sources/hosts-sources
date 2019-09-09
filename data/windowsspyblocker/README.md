<p align="center"><a href="https://github.com/crazy-max/WindowsSpyBlocker" target="_blank"><img width="100"src="https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/.res/logo.png"></a></p>

<p align="center">
  <a href="https://github.com/crazy-max/WindowsSpyBlocker/releases/latest"><img src="https://img.shields.io/github/release/crazy-max/WindowsSpyBlocker.svg?style=flat-square" alt="GitHub release"></a>
  <a href="https://chocolatey.org/packages/windowsspyblocker"><img src="https://img.shields.io/chocolatey/v/windowsspyblocker?style=flat-square" alt="Chocolatey Package"></a>
  <a href="https://github.com/crazy-max/WindowsSpyBlocker/releases/latest"><img src="https://img.shields.io/github/downloads/crazy-max/WindowsSpyBlocker/total.svg?style=flat-square" alt="Total downloads"></a>
  <a href="https://github.com/crazy-max/WindowsSpyBlocker/actions"><img src="https://github.com/crazy-max/WindowsSpyBlocker/workflows/build/badge.svg" alt="Build Status"></a>
  <a href="https://goreportcard.com/report/github.com/crazy-max/WindowsSpyBlocker"><img src="https://goreportcard.com/badge/github.com/crazy-max/WindowsSpyBlocker?style=flat-square" alt="Go Report"></a>
  <a href="https://www.codacy.com/app/crazy-max/WindowsSpyBlocker"><img src="https://img.shields.io/codacy/grade/1e2eae1a40754d88b7956cf9bd30241b.svg?style=flat-square" alt="Code Quality"></a>
  <br /><a href="https://www.patreon.com/crazymax"><img src="https://img.shields.io/badge/donate-patreon-f96854.svg?logo=patreon&style=flat-square" alt="Support me on Patreon"></a>
  <a href="https://www.paypal.me/crazyws"><img src="https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square" alt="Donate Paypal"></a>
</p>

## About

**WindowsSpyBlocker** :shield: is an application written in [Go](https://golang.org/) and delivered as a [single executable](https://github.com/crazy-max/WindowsSpyBlocker/releases/latest) to block spying and tracking on Windows systems :no_entry:.

The approach of this project is to capture and interpret network traffic :vertical_traffic_light: based on a set of tools. Depending on the interactions :chains: between services and source or destination of traffic, rules are created and sorted by assignment.

![](.res/wsb-main-window.png)
> Main window of WindowsSpyBlocker

Configuration file `app.conf` is generated at first launch :

![](.res/wsb-root-folder.png)

For more info, take a look at [Wiki](../../wiki).

## Download

WindowsSpyBlocker executable can be downloaded directly from [GitHub releases](https://github.com/crazy-max/WindowsSpyBlocker/releases/latest) or as a [Chocolate package](https://chocolatey.org/packages/windowsspyblocker) that will allow you to benefit from automatic updates.

## Telemetry and data collection

To capture and interpret network traffic, QEMU virtual machines are used on the server virtualization management platform [Proxmox VE](https://www.proxmox.com/en/) based on :

* Windows 10 Pro 64bits with automatic updates enabled.
* Windows 8.1 Pro 64bits with automatic updates enabled.
* Windows 7 SP1 Pro 64bits with automatic updates enabled.

Traffic dumps are cleaned monthly and compared with the current rules to add or remove some hosts or firewall rules.

Tools used to capture traffic :

* `qemu -net dump` : capture
* [Wireshark](../../wiki/appDevWireshark) : capture + logs
* [Sysmon](../../wiki/appDevSysmon) : capture + logs
* [Proxifier](../../wiki/devProxifier) : logs

The `data` folder contains the blocking rules based on domains or IPs detected during the capture process :

* `data/<type>/extra.txt` : Block third party applications (Skype, Bing, Live, Outlook, NCSI, etc.)
* `data/<type>/spy.txt` : Block Windows Spy / Telemetry **recommended**
* `data/<type>/update.txt` : Block Windows Update
* `data/hosts/[extra|spy|update]_v6.txt` : Handle IPv6 blocking for hosts

[Firewall](../../wiki/dataFirewall) and [Hosts](../../wiki/dataHosts) data are the main types. The others are generated from these as :

* [DNSCrypt](../../wiki/dataDNSCrypt) : a protocol for securing communications between a client and a DNS resolver.
* [OpenWrt](../../wiki/dataOpenWrt) : an open source project used on embedded devices to route network traffic.
* [P2P](../../wiki/dataP2P) : a plaintext IP data format from PeerGuardian.
* [Proxifier](../../wiki/dataProxifier) : an advanced proxy client on Windows with a flexible rule system.
* [simplewall](../../wiki/dataSimplewall) : a simple tool to configure Windows Filtering Platform (WFP).

And about data collection, you can read the [Telemetry collection](../../wiki/miscTelemetry) page for more info.

## Projects using WindowsSpyBlocker

* [BlackArch Linux](https://www.blackarch.org/) : an Arch Linux-based penetration testing distribution for penetration testers and security researchers.
* [Blackweb](https://github.com/maravento/blackweb) : URLs Blacklist for Squid
* [BlahDNS](https://blahdns.com/) : A small hobby ads block dns project with doh, dot, dnscrypt support.
* [DNSCrypt Proxy](https://dnscrypt.info/) : A flexible DNS proxy, with support for encrypted DNS protocols.
* [Energized Protection](https://energized.pro/) : Let's make an annoyance free, better open internet, altogether!
* [FilterLists](https://filterlists.com/) : An independent, comprehensive directory of filter and host lists for advertisements, trackers, malware, and annoyances.
* [LEDE Project](https://lede-project.org/) : A Linux operating system based on OpenWrt.
* [Mikrotik hosts parser](https://github.com/tarampampam/mikrotik-hosts-parser) : An application that blocks "advertising" for routers based on RouterOS.
* [OpenWrt adblock package](https://github.com/openwrt/packages/tree/master/net/adblock/files) : DNS based ad/abuse domain blocking
* [OPNsense](https://opnsense.org) : An open source, easy-to-use and easy-to-build HardenedBSD based firewall and routing platform.
* [pi-hole](https://pi-hole.net/) : A black hole for Internet advertisements (designed for Raspberry Pi).
* [simplewall](https://github.com/henrypp/simplewall) : Simple tool to configure Windows Filtering Platform (WFP).
* [void-zones-tools](https://github.com/cyclaero/void-zones-tools) : A list of void zones that can be readily feed into Unbound on FreeBSD.
* [WPD](https://getwpd.com/) : Customize Group Policy, Services and Tasks, responsible for data collection and sending, as you like.

## How can I help ?

All kinds of contributions are welcome :raised_hands:!<br />
The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon:<br />
But we're not gonna lie to each other, I'd rather you buy me a beer or two :beers:!

[![Support me on Patreon](.res/patreon.png)](https://www.patreon.com/crazymax) 
[![Paypal](.res/paypal.png)](https://www.paypal.me/crazyws)

## License

MIT. See `LICENSE` for more details.<br />
Icon credit to [Icons8](https://icons8.com/).
