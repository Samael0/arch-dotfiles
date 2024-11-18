#!/usr/bin/env bash
#|---/ /+-------------------------------------------+---/ /|#
#|--/ /-| Script to install aur helper, yay or paru |--/ /-|#
#|-/ /--| Prasanth Rangan                           |-/ /--|#
#|/ /---+-------------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
# shellcheck disable=SC1091
if ! source "${scrDir}/global_fn.sh"; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

# shellcheck disable=SC2154
if chk_list "aurhlpr" "${aurList[@]}"; then
    print_log -g "[AUR]" -b "detected :: " "${aurhlpr}"
    exit 0
fi

aurhlpr="${1:-yay}"

if [ -d "$HOME/Clone" ]; then
    print_log -g "[AUR]" -b "exist :: " "$HOME/Clone directory..."
    rm -rf "$HOME/Clone/${aurhlpr}"
else
    mkdir "$HOME/Clone"
    echo -e "[Desktop Entry]\nIcon=default-folder-git" >"$HOME/Clone/.directory"
    print_log -g "[AUR]" -b "created :: " "$HOME/Clone directory..."
fi

if pkg_installed git; then
    git clone "https://aur.archlinux.org/${aurhlpr}.git" "$HOME/Clone/${aurhlpr}"
else
    print_log -r "[AUR]" -b "missing :: " "git dependency..."
    exit 1
fi

cd "$HOME/Clone/${aurhlpr}" || exit
# shellcheck disable=SC2154
if makepkg "${use_default}" -si; then
    print_log -g "[AUR]" -b "installed :: " "${aurhlpr} aur helper..."
    exit 0
else
    print_log -r "[AUR]" -b "failed :: " "${aurhlpr} installation failed..."
    echo "${aurhlpr} installation failed..."
    exit 1
fi
