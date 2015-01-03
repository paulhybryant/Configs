find . -path '*/.git*' -prune -o -type f -exec chmod a-x {} \;
