import sys
import urllib2

URL = "http://dot.b4b4r07.com"
url = urllib2.urlopen(URL).geturl()

if not url == "https://raw.githubusercontent.com/b4b4r07/dotfiles/master/etc/install":
    sys.exit(1)

print 'ok: %s <-> %s' % (URL, url)
