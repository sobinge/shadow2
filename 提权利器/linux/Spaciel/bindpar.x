#!/bin/sh
inf="Vad Bind"

BLK='[1;30m'
RED='[1;31m'
GRN='[1;32m'
YEL='[1;33m'
BLU='[1;34m'
MAG='[1;35m'
CYN='[1;36m'
WHI='[1;37m'
DRED='[0;31m'
DGRN='[0;32m'
DYEL='[0;33m'
DBLU='[0;34m'
DMAG='[0;35m'
DCYN='[0;36m'
DWHI='[0;37m'

echo "${WHI}Vad $1pe ${DWHI}`hostname -f`"
echo "${BLU}Afishez 8.2 and 8.2.1 din ${RED}$1${WHI}"
cat $1 | grep 8.2 | grep -v 8.2.2 | grep -v 8.2.3 | grep -v 8.1 | grep -v 4.9 | grep -v LOCAL
echo "${RED}Gata${DWHI}"
