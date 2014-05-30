# Description

This repository is b4b4r07's config files.

Only the files that have execute permissions(755) on the directory MASTERD, read at startup.

```
if [ -d $MASTERD ] ; then
	echo -en "\n"
	for f in $MASTERD/*.sh ; do
		[ ! -x "$f" ] && . "$f" && echo load "$f"
	done
	echo -en "\n"
	unset f
fi
```
