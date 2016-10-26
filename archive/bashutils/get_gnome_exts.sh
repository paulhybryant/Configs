#!/bin/bash

#We want the new-line to remain
old_ifs=${IFS}
IFS=$'
'

# CACHE="${HOME}/.cache/gnomeextget/gnomeExtGet.txt"

#Get the names of the extensions
EXT=$(grep "name\":" ~/.local/share/gnome-shell/extensions/*/metadata.json /usr/share/gnome-shell/extensions/*/metadata.json | awk -F '"name": "|",' '{print $2}')

echo $EXT

# echo "[Looking up extensions...]"
# echo

# # Creates cache dir if not exist.
# if [ ! -e "${HOME}/.cache/gnomeextget/" ]; then
  # mkdir ${HOME}/.cache/gnomeextget/
  # touch ${HOME}/.cache/gnomeextget/gnomeExtGet.txt
# fi

# # Delete lines of removed extensions.
# if [ "grep -v $EXT ${HOME}/.cache/gnomeextget/gnomeExtGet.txt" ]; then
  # sed -i "/$(grep -v "$EXT" ${HOME}/.cache/gnomeextget/gnomeExtGet.txt|cut -d "-" -f 1)/d" ${HOME}/.cache/gnomeextget/gnomeExtGet.txt
# fi

# # Find urls to the extensions
for n in ${EXT};
do
  echo $n
  # EXTFIND=$(grep -l "${n}" ~/.local/share/gnome-shell/extensions/*/metadata.json /usr/share/gnome-shell/extensions/*/metadata.json)

  # #Curl don't like blank spaces so use %20
  # i=$(echo "${n}" | sed 's/ /%20/g')

  # if [ "$(grep ${n} ${HOME}/.cache/gnomeextget/gnomeExtGet.txt)" ]; then
    # URL=$(grep "${n}" ${HOME}/.cache/gnomeextget/gnomeExtGet.txt) #If exist skip googling this one.
  # else
    # URL=$(curl -A 'Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20100101 Firefox/17.0' --silent "https://www.google.com/search?q=site:extensions.gnome.org%20${i}" | grep -io "<a href=\"https://extensions.gnome.org/extension/.*(this,'','','','1'," | awk -F '<a href="|" class=1*' '{print $2}')

    # #If urls not on extensions.gnome.org use the one in metadata.json
    # if [ "${URL}" = "" ]; then
        # URL=$(grep "url\":" ${EXTFIND} | awk -F '"url": "|",*' '{print $2}')
    # fi

    # #Print out the nice list
    # echo "${n} - (${URL})" >> $HOME/.cache/gnomeextget/gnomeExtGet.txt
  # fi
done
# | zenity --progress --pulsate --auto-close

# zenity --text-info --width=850 --height=800 --title="My Gnome Extensions" --filename=${HOME}/.cache/gnomeextget/gnomeExtGet.txt

# echo
# echo "[Done!]"

IFS=${old_ifs}

