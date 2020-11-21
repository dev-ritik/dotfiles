#!/bin/bash

set -C -f -u
#IFS=$'\n'
IFS="$(printf '%b_' '\n')"; IFS="${IFS%_}"

# ANSI color codes are supported.
# STDIN is disabled, so interactive scripts won't work properly

# This script is considered a configuration file and must be updated manually.

# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | Display stdout as preview
# 1    | no preview | Display no preview at all
# 2    | plain text | Display the plain content of the file

# Script arguments
FILE_PATH="${1}"         # Full path of the highlighted file
HEIGHT="${2}"

#FILE_EXTENSION="${FILE_PATH##*.}"
#FILE_EXTENSION_LOWER=$(echo ${FILE_EXTENSION} | tr '[:upper:]' '[:lower:]')

# Settings
HIGHLIGHT_SIZE_MAX=262143  # 256KiB
HIGHLIGHT_TABWIDTH=8
HIGHLIGHT_STYLE='pablo'

# Calculate where the image should be placed on the screen.
num=$(printf "%0.f\n" "`echo "$(tput cols) / 2" | bc`")
numb=$(printf "%0.f\n" "`echo "$(tput cols) - $num - 1" | bc`")
numc=$(printf "%0.f\n" "`echo "$(tput lines) - 2" | bc`")

case "$1" in
    *.tgz|*.tar.gz) tar tzf "$1";;
    *.tar.bz2|*.tbz2) tar tjf "$1";;
    *.tar.txz|*.txz) xz --list "$1";;
    *.tar) tar tf "$1";;
    *.zip|*.jar|*.war|*.ear|*.oxt) unzip -l "$1";;
    *.rar) unrar l "$1";;
    *.7z) 7z l "$1";;
    *.[1-8]) man "$1" | col -b ;;
    *.o) nm "$1" | less ;;
    *.torrent) transmission-show "$1";;
    *.iso) iso-info --no-header -l "$1";;
    *odt,*.ods,*.odp,*.sxw) odt2txt "$1";;
    *.doc) catdoc "$1" ;;
    *.docx) docx2txt "$1" - ;;
    *.csv) cat "$1" | sed s/,/\\n/g ;;
    *pdf) pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - ;;
    *) highlight --out-format ansi "$1" || cat "$1";;
esac

exit 1