#!/bin/bash

set -u # check all variable has been set

dconfdir=/org/gnome/terminal/legacy/profiles:

create_new_profile() {
    local profile_ids=($(dconf list $dconfdir/ | grep ^: |\
                        sed 's/\///g' | sed 's/://g'))
    local profile_name="$1"
    local profile_ids_old="$(dconf read "$dconfdir"/list | tr -d "]")"
    local profile_id="$(uuidgen)"

    [ -z "$profile_ids_old" ] && local profile_ids_old="["  # if there's no `list` key
    [ ${#profile_ids[@]} -gt 0 ] && local delimiter=,  # if the list is empty
    dconf write $dconfdir/list \
        "${profile_ids_old}${delimiter} '$profile_id']"
    dconf write "$dconfdir/:$profile_id"/visible-name "'$profile_name'"
    echo $profile_id
}



# Create profile
id=$(create_new_profile $1)

gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 20'

dconf write $dconfdir/default "'$id'"
