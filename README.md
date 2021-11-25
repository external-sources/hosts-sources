# External Sources

This repo is all about collecting bad domains and transcode them into usefull
clean data.

This means other processes don't have to do this time after time, 
wasting CI-Runner time, on doing the same job several times, by cleaning up data 
first.... That's about it. :smiley: :o:

These list should be updated every 4 hours at the 54 minute. This means the 
processed list should be availble around 00 minuts.

# How to search

The optimal way to search through this library of know hosts and domain names
to be blacklisted is to use the `git grep ''` command, that will the the git
database rather than searching through the folders (Disk I/O).

A few copy paste lines for exstending/limiting the results replayed bit git

No explainer will be added ass if you don't know these simle grep + Regex,
You have something to read up on before throwing your self into generating/
maintaining blacklists

```bash
SEARCH="\.iad2\.secureserver\.net$"
git grep "${SEARCH}"
git grep "${SEARCH}" | grep -E '(/phis|/phs/)'
git grep "${SEARCH}" | grep -E '(/phis|/phs/)' | cut -d : -f 2 | sort -u
```
