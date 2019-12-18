# FAQ
### What is OpenPhish?

OpenPhish is a fully automated self-contained platform for phishing 
intelligence. It identifies phishing sites and performs intelligence 
analysis in real time without human intervention and without using any 
external resources, such as blacklists.

### How does OpenPhish collect phishing URLs?

OpenPhish receives millions of unfiltered URLs from a variety of 
sources on its global partner network. The phishing detection engine of 
OpenPhish singles out live phishing URLs and extracts their metadata, 
which includes targeted brands (when applicable), network and 
geographical locations, phishing kits and drop accounts.

### Why certain known phishing URLs are not listed on OpenPhish?

OpenPhish reports only new and live phishing URLs. We keep track of the 
detected phishing URLs and do not report any URL more than once within 
any given 14-day period. We do not report any dead phishing URLs as they 
do not pose any threat.

### How can I report phishing URLs?

There are three ways to share URLs with us:

* Email: send the URLs to a designated email address.
* API: send the URLs using a REST API (static IP is required).
* Provide us access to an endpoint you control. We will periodically 
	pull the URLs from you.

If you are interested in sharing URLs with us, please contact us at 
contact@openphish.com for more information.

### How can I remove my website from your feed?

The short answer - you can't. OpenPhish neither maintains its own 
blacklist nor can remove your website from third party blacklists. 
OpenPhish only provides a feed of exact live phishing URLs and never 
flags the entire website/domain as malicious. If you have questions 
about a specific URL related to your website, please email us at 
support@openphish.com.

### How can I report a False Positive?

First, please refer to the False Positive Feed to check if we are 
already aware of the false positive. If the URL is not in the feed and 
you believe that we incorrectly identified a phishing URL, please let 
us know at support@openphish.com.
