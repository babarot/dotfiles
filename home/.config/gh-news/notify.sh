#!/bin/sh
# Called by gh-news for each new notification (see config.toml)
osascript -e "display notification \"$GH_NEWS_TITLE\" with title \"$GH_NEWS_REPO ($GH_NEWS_REASON)\""
