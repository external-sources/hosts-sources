https://github.com/crazy-max/WindowsSpyBlocker/blob/master/data/hosts/spy.txt 
-    ### WindowsSpyBlocker - Hosts spy rules
-    ### License: MIT
-    ### Updated: 2019-03-02T02:05:00Z01:00
-    ### More info: https://github.com/crazy-max/WindowsSpyBlocker

## Import by

```shell
curl -sS -L --compressed "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt" | cut -d' ' -f2 | awk '/[a-z]$/{print $0}' >> {$curltemp,,}
```
